import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/core/firebase/firebase.dart';
import 'package:profind/features/home/presentation/pages/home_page.dart';
import 'package:profind/features/login/domain/usecase/authenticate_usecase.dart';
import 'package:profind/features/login/presentation/bloc/authenticate_bloc.dart';
import 'package:profind/features/registration/presentation/pages/registration_personal_info_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;
  final firebaseService = AuthService();
  bool isRegistering = false;
  bool isLoading = false;
  bool _isObscurePassword = true;
  String? _userType;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _showUserTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecione o tipo de cadastro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Cliente'),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.pop(context);
                setState(() => _userType = 'client');
                _navigateToRegistration();
              },
            ),
            ListTile(
              title: const Text('Prestador de Serviço'),
              leading: const Icon(Icons.handyman),
              onTap: () {
                Navigator.pop(context);
                setState(() => _userType = 'service_provider');
                _navigateToRegistration();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage(
          userType: _userType.toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            spacing: MediaQuery.of(context).size.height * 0.001,
            children: [
              Image.asset(
                'assets/images/logo_app.png',
              ),
              Form(
                key: _formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      onEditingComplete: () => _passwordFocus.requestFocus(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        label: Text("E-Mail"),
                        hintText: 'Digite seu e-mail',
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "E-mail obrigatório.";
                        }

                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );

                        if (!emailRegex.hasMatch(value)) {
                          return "E-mail inválido.";
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscurePassword = !_isObscurePassword;
                            });
                          },
                          icon: _isObscurePassword
                              ? const Icon(Icons.visibility_outlined)
                              : const Icon(Icons.visibility_off_outlined),
                        ),
                        label: Text("Senha"),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Senha obrigatória.";
                        }
                        if (value.trim().length < 8) {
                          return "Senha deve conter no mínimo 8 caractéres";
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Não possui uma conta?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            _showUserTypeDialog();
                          },
                          child: Text(
                            "Registre-se",
                            style: TextStyle(color: const Color(0xFFfa7f3b)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthenticateBloc>().add(
                            LoginEvent(
                              AuthenticateParams(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ),
                            ),
                          );

                      try {
                        if (isRegistering) {
                          await firebaseService.registerWithEmailAndPassword(
                            _emailController.text,
                            _passwordController.text,
                          );
                          context.pushReplacement(HomePage.routeName);
                        } else {
                          final user =
                              await firebaseService.signInWithEmailAndPassword(
                            _emailController.text,
                            _passwordController.text,
                          );

                          if (user != null) {
                            context.pushReplacement(HomePage.routeName);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Falha ao fazer login. Verifique suas credenciais.")),
                            );
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$e")),
                        );
                      }
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      color: const Color(0xFFfa7f3b),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: BlocConsumer<AuthenticateBloc, AuthenticateState>(
                        listener: (context, state) {
                          if (state is AuthenticateError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          if (state is AuthenticateSuccess) {
                            context.pushReplacement(HomePage.routeName);
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthenticateLoading) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                          return Text(
                            "Entrar",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
