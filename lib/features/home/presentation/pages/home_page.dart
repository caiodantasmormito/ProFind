import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/features/login/presentation/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<int>(
            color: Colors.white,
            icon: const Icon(Icons.menu, color: Colors.black),
            onSelected: (value) {
              if (value == 0) {
                FirebaseAuth.instance.signOut();
                context.pushReplacement(LoginPage.routeName);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Sair'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(child: Text('HOME PAGE')),
    );
  }
}
