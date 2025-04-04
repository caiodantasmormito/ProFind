import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/features/login/presentation/pages/login_page.dart';
import 'package:profind/core/widgets/profind_button.dart';

class ServiceProviderHomePage extends StatelessWidget {
  const ServiceProviderHomePage({super.key});
  static const String routeName = '/serviceProvider';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Meu Perfil de Prestador'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo, Prestador!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              InkWell(
                  onTap: () {}, child: ProfindButton(label: 'Editar perfil')),
              InkWell(
                  onTap: () {},
                  child: ProfindButton(label: 'Meus agendamentos')),
            ],
          ),
        ),
      ),
    );
  }
}
