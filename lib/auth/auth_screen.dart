import 'package:flutter/material.dart';
import 'package:epiverse/auth/login_tab.dart';
import 'package:epiverse/auth/registration_tab.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Wide screen layout
            return const Row(
              children: [
                Expanded(child: LoginTab()),
                VerticalDivider(width: 1),
                Expanded(child: RegistrationTab()),
              ],
            );
          } else {
            // Narrow screen layout
            return Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.login), text: 'Login'),
                    Tab(icon: Icon(Icons.person_add), text: 'Register'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      LoginTab(),
                      RegistrationTab(),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
