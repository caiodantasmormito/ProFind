import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/features/login/presentation/pages/login_page.dart';
import 'package:profind/features/registration/data/datasource/registration_datasource.dart';

class EmailVerificationPage extends StatefulWidget {
  final String userId;
  final String email;

  const EmailVerificationPage({
    required this.userId,
    required this.email,
    super.key,
  });
  static const routeName = '/emailVerification';

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startVerificationTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startVerificationTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        await context
            .read<RegistrationDataSource>()
            .checkAndUpdateEmailVerification(widget.userId);

        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.emailVerified) {
          _timer?.cancel();
          if (mounted) {
            context.pushReplacement(LoginPage.routeName);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Erro ao verificar e-mail: ${e.toString()}')),
          );
        }
      }
    });
  }

  Future<void> _resendVerificationEmail() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('E-mail de verificação reenviado!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao reenviar e-mail: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificação de E-mail')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email_outlined, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              const Text(
                'Verifique seu e-mail',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Enviamos um e-mail de verificação para ${widget.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator(
                  color: Colors.white,
                )
              else
                ElevatedButton(
                  onPressed: _resendVerificationEmail,
                  child: const Text('Reenviar e-mail de verificação'),
                ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  context.pushReplacement(LoginPage.routeName);
                },
                child: const Text('Voltar para login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
