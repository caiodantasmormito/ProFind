import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:profind/arguments/validate_email_arguments.dart';
import 'package:profind/features/registration/presentation/pages/validate_email_page.dart';

// ignore: must_be_immutable
class ClientRegistrationPage extends StatefulWidget {
  ClientRegistrationPage({super.key, required this.userType});

  static const routeName = '/registrationClient';
  String userType;

  @override
  State<ClientRegistrationPage> createState() => _ClientRegistrationPageState();
}

class _ClientRegistrationPageState extends State<ClientRegistrationPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;

  late final TextEditingController _surnameController;
  late final TextEditingController _cpfController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;

  late final TextEditingController _cepController;
  late final TextEditingController _ufController;

  late final FocusNode _cityFocus;
  late final FocusNode _phoneFocus;

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

    _cepController = TextEditingController();
    _addressController = TextEditingController();

    _phoneController = TextEditingController();

    _formKey = GlobalKey<FormState>();
    _cityFocus = FocusNode();
    _phoneFocus = FocusNode();

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

    _cepController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _cpfFocus.dispose();

    _cepFocus.dispose();
    _addressFocus.dispose();

    _cityFocus.dispose();
    _ufFocus.dispose();
    _surnameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Informações Pessoais'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocus,
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
                focusNode: _surnameFocus,
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
                inputFormatters: [cpfFormatter],
                keyboardType: TextInputType.number,
                focusNode: _cpfFocus,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CPF é obrigatório';
                  } else if (!CPFValidator.isValid(value)) {
                    return 'CPF inexistente';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                inputFormatters: [phoneFormatter],
                focusNode: _phoneFocus,
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
              if (widget.userType == 'service_provider')
                Text('PRESTADOR DE SERVIÇO'),
              TextFormField(
                focusNode: _cepFocus,
                controller: _cepController,
                inputFormatters: [cepFormatter],
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CEP é obrigatório';
                  }
                  return null;
                },
                /*onChanged: () {
      
                },*/
              ),
              TextFormField(
                controller: _addressController,
                focusNode: _addressFocus,
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
                focusNode: _cityFocus,
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
                //readOnly: true,
                controller: _ufController,
                focusNode: _ufFocus,
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
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    context.push(
                      ValidateEmailPage.routeName,
                      extra: ValidateEmailArguments(
                              name: _nameController.text,
                              surname: _surnameController.text,
                              cpf: _cpfController.text,
                              cep: _cepController.text,
                              city: _cityController.text,
                              phone: _phoneController.text,
                              uf: _ufController.text,
                              address: _addressController.text)
                          .toJson(),
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
                    child: Text(
                      "Continuar",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
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
