import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:profind/features/registration/domain/usecases/registration_client_usecase.dart';
import 'package:profind/features/registration/presentation/bloc/registration_client/registration_client_bloc.dart';

class ClientRegistrationPage extends StatefulWidget {
  const ClientRegistrationPage({
    super.key,
  });
  static const routeName = '/registrationClient';

  @override
  State<ClientRegistrationPage> createState() => _ClientRegistrationPageState();
}

class _ClientRegistrationPageState extends State<ClientRegistrationPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _surnameController;
  late final TextEditingController _cpfController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;

  late final TextEditingController _cepController;
  late final TextEditingController _ufController;

  late final FocusNode _cityFocus;
  late final FocusNode _phoneFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;

  late final FocusNode _nameFocus;
  late final FocusNode _cpfFocus;
  late final FocusNode _surnameFocus;
  late final FocusNode _cepFocus;
  late final FocusNode _addressFocus;
  late final FocusNode _ufFocus;

  MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp('[0-9]')},
  );
  MaskTextInputFormatter cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp('[0-9]')},
  );
  MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp('[0-9]')},
  );

  @override
  void initState() {
    _cityController = TextEditingController();
    _ufController = TextEditingController();
    _surnameController = TextEditingController();
    _nameController = TextEditingController();
    _cpfController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();

    _cepController = TextEditingController();
    _addressController = TextEditingController();

    _phoneController = TextEditingController();

    _formKey = GlobalKey<FormState>();
    _cityFocus = FocusNode();
    _phoneFocus = FocusNode();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _nameFocus = FocusNode();
    _cpfFocus = FocusNode();
    _ufFocus = FocusNode();
    _surnameFocus = FocusNode();

    _cepFocus = FocusNode();
    _addressFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _ufController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _cepController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _cpfFocus.dispose();
    _emailFocus.dispose();
    _cepFocus.dispose();
    _addressFocus.dispose();
    _passwordFocus.dispose();
    _cityFocus.dispose();
    _ufFocus.dispose();
    _surnameFocus.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final params = ClientRegistrationParams(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          surname: _surnameController.text,
          cpf: _cpfController.text,
          city: _cityController.text,
          uf: _ufController.text,
          cep: _cepController.text,
          phone: _phoneController.text,
          address: _addressController.text);

      context.read<RegistrationClientBloc>().add(
            RegistrationClient(params: params),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Cliente'),
      ),
      body: BlocListener<RegistrationClientBloc, RegistrationClientState>(
        listener: (context, state) {
          if (state is RegistrationClientSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is RegistrationClientError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu E-mail';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _surnameController,
                  decoration: const InputDecoration(
                    labelText: 'Sobrenome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu sobrenome';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cpfController,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu CPF';
                    }
                    if (value.length != 11) {
                      return 'CPF deve ter 11 dígitos';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu telefone';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Endereço',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu endereço';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'Cidade',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua cidade';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ufController,
                  decoration: const InputDecoration(
                    labelText: 'Estado (UF)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu estado';
                    }
                    if (value.length != 2) {
                      return 'UF deve ter 2 caracteres';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cepController,
                  decoration: const InputDecoration(
                    labelText: 'CEP',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu CEP';
                    }
                    if (value.length != 8) {
                      return 'CEP deve ter 8 dígitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<RegistrationClientBloc, RegistrationClientState>(
                  builder: (context, state) {
                    if (state is RegistrationClientLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Completar Cadastro'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
