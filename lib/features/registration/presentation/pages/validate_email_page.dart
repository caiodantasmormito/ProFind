import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/arguments/validate_email_arguments.dart';
import 'package:profind/features/home/presentation/pages/home_page.dart';
import 'package:profind/features/login/presentation/pages/login_page.dart';
import 'package:profind/features/registration/domain/usecases/registration_usecase.dart';
import 'package:profind/features/registration/presentation/bloc/registration_client/registration_bloc.dart';

// ignore: must_be_immutable
class ValidateEmailPage extends StatefulWidget {
  const ValidateEmailPage(
      {required this.arguments, required this.userType, super.key});
  static const routeName = '/validateEmail';
  final ValidateEmailArguments arguments;
  final String userType;

  @override
  State<ValidateEmailPage> createState() => _ValidateEmailPageState();
}

class _ValidateEmailPageState extends State<ValidateEmailPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;
  late final GlobalKey<FormState> _formKey;
  bool _isObscurePassword = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: SafeArea(
            child: Text(
          'Criar conta',
        )),
        backgroundColor: Colors.white,
      ),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            context.pushReplacement(HomePage.routeName);
          } else if (state is RegistrationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informe um e-mail para cadastro.',
                  style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  textCapitalization: TextCapitalization.none,
                  controller: _emailController,
                  focusNode: _emailFocus,
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
                  decoration: const InputDecoration(
                    labelText: 'Digite seu e-mail para cadastro',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: _isObscurePassword,
                  decoration: InputDecoration(
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
                    labelText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Password obrigatório.";
                    }
                    if (value.trim().length < 8) {
                      return "Password deve conter no mínimo 8 caractéres";
                    }
                    return null;
                  },
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final params = RegistrationParams(
                          email: _emailController.text,
                          password: _passwordController.text,
                          name: widget.arguments.name,
                          surname: widget.arguments.surname,
                          cpf: widget.arguments.cpf,
                          city: widget.arguments.city,
                          uf: widget.arguments.uf,
                          cep: widget.arguments.cep,
                          phone: widget.arguments.phone,
                          userType: widget.arguments.userType,
                          address: widget.arguments.address);

                      context.read<RegistrationBloc>().add(
                            RegisterUserEvent(params),
                          );
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                        color: const Color(0xFFfa7f3b),
                        border: Border.all(
                            color: const Color(
                          0xFFEEEEEE,
                        )),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: BlocBuilder<RegistrationBloc, RegistrationState>(
                        builder: (context, registerState) {
                          if (registerState is RegistrationLoading) {
                            return CircularProgressIndicator();
                          }
                          return Text(
                            "Continuar",
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Já possui uma conta? ',
                      style: TextStyle(
                        color: Color(0xFF999999),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.pushReplacement(LoginPage.routeName);
                      },
                      child: const Text(
                        'Fazer login',
                        style: TextStyle(color: Color(0xFFfa7f3b)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
