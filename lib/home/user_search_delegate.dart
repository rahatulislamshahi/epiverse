import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../chat/chat_screen.dart';

class UserSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text("You need to be logged in to search for users."),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs
            .where((doc) => doc['email'] != currentUser.email && (doc['username'] as String? ?? '').toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final username = user['username'] ?? 'No username';
            final email = user['email'] ?? 'No email';

            return ListTile(
              title: Text(username),
              subtitle: Text(email),
              onTap: () {
                close(context, null); // Close the search
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(userId: user.id, userName: username),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
