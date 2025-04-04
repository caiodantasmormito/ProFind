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
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _startVerificationTimer();
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    super.dispose();
  }

  void _startVerificationTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      try {
        if (!mounted) return;

        final dataSource = context.read<RegistrationDataSource>();
        await dataSource.checkAndUpdateEmailVerification(widget.userId);

        if (_isDisposed) return;

        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.emailVerified) {
          timer.cancel();
          if (!mounted) return;
          
          // Navegando de forma segura
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.go(LoginPage.routeName);
            }
          });
        }
      } catch (e) {
        if (!mounted || _isDisposed) return;
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao verificar e-mail: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    });
  }

  Future<void> _resendVerificationEmail() async {
    if (_isDisposed) return;

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        if (!mounted || _isDisposed) return;
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('E-mail de verificação reenviado!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        });
      }
    } catch (e) {
      if (!mounted || _isDisposed) return;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao reenviar e-mail: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    } finally {
      if (mounted && !_isDisposed) {
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
                SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    onTap: () async {
                      _resendVerificationEmail;
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: const Color(0xFFfa7f3b),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                          child: Text(
                        'Reenviar e-mail de verificação',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      )),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  context.go(LoginPage.routeName);
                },
                child: const Text(
                  'Fazer login',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFfa7f3b)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
