import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epiverse/auth/auth_screen.dart';
import 'package:epiverse/chat/chat_screen.dart';
import 'package:epiverse/profile/profile_screen.dart';
import 'package:epiverse/home/user_search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // This should ideally not happen if AuthWrapper is working correctly
      return const AuthScreen(); 
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: UserSearchDelegate());
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('users', arrayContains: currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats yet. Start a conversation!'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final chatData = doc.data() as Map<String, dynamic>;
              final List<String> userIds = List<String>.from(chatData['users']);
              final otherUserId = userIds.firstWhere((id) => id != currentUser.uid, orElse: () => '');

              if (otherUserId.isEmpty) {
                // Handle cases where other user is not found (e.g., in a group chat with only one user)
                return const SizedBox.shrink(); 
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text('Loading...'));
                  }
                  if (userSnapshot.hasError || !userSnapshot.hasData || userSnapshot.data!.data() == null) {
                    return const ListTile(title: Text('User not found'));
                  }

                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  final username = userData['username'] ?? 'Unknown User';

                  return ListTile(
                    title: Text(username),
                    subtitle: Text(chatData['lastMessage'] ?? ''),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(userId: otherUserId, userName: username),
                        ),
                      );
                    },
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
