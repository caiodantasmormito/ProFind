import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:profind/arguments/validate_email_arguments.dart';
import 'package:profind/features/registration/presentation/pages/validate_email_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.userType});

  static const routeName = '/registration';
  final String userType;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _cpfController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _cepController;
  late final TextEditingController _ufController;
  late final TextEditingController _serviceController;

  late final FocusNode _cityFocus;
  late final FocusNode _phoneFocus;
  late final FocusNode _nameFocus;
  late final FocusNode _cpfFocus;
  late final FocusNode _surnameFocus;
  late final FocusNode _cepFocus;
  late final FocusNode _addressFocus;
  late final FocusNode _ufFocus;
  late final FocusNode _serviceFocus;

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp('[0-9]')},
  );

  final cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp('[0-9]')},
  );

  final phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp('[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeFocusNodes();
    _formKey = GlobalKey<FormState>();
  }

  void _initializeControllers() {
    _cityController = TextEditingController();
    _ufController = TextEditingController();
    _surnameController = TextEditingController();
    _nameController = TextEditingController();
    _cpfController = TextEditingController();
    _cepController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _serviceController = TextEditingController();
  }

  void _initializeFocusNodes() {
    _cityFocus = FocusNode();
    _phoneFocus = FocusNode();
    _nameFocus = FocusNode();
    _cpfFocus = FocusNode();
    _ufFocus = FocusNode();
    _surnameFocus = FocusNode();
    _cepFocus = FocusNode();
    _addressFocus = FocusNode();
    _serviceFocus = FocusNode();
  }

  @override
  void dispose() {
    _disposeControllers();
    _disposeFocusNodes();
    super.dispose();
  }

  void _disposeControllers() {
    _nameController.dispose();
    _surnameController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _ufController.dispose();
    _cepController.dispose();
    _serviceController.dispose();
  }

  void _disposeFocusNodes() {
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _cpfFocus.dispose();
    _cepFocus.dispose();
    _addressFocus.dispose();
    _cityFocus.dispose();
    _ufFocus.dispose();
    _surnameFocus.dispose();
    _serviceFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.userType == 'client'
            ? 'Cadastro de Cliente'
            : 'Cadastro de Prestador'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
              _buildNameField(),
              _buildSurnameField(),
              _buildCpfField(),
              _buildPhoneField(),
              if (widget.userType == 'service_provider') _buildServiceField(),
              _buildCepField(),
              _buildAddressField(),
              _buildCityField(),
              _buildUfField(),
              const SizedBox(height: 24),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      focusNode: _nameFocus,
      decoration: const InputDecoration(
        labelText: 'Nome',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Por favor, insira seu nome' : null,
    );
  }

  Widget _buildSurnameField() {
    return TextFormField(
      controller: _surnameController,
      focusNode: _surnameFocus,
      decoration: const InputDecoration(
        labelText: 'Sobrenome',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Por favor, insira seu sobrenome' : null,
    );
  }

  Widget _buildCpfField() {
    return TextFormField(
      controller: _cpfController,
      inputFormatters: [cpfFormatter],
      keyboardType: TextInputType.number,
      focusNode: _cpfFocus,
      decoration: const InputDecoration(
        labelText: 'CPF',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'CPF é obrigatório';
        if (!CPFValidator.isValid(value)) return 'CPF inexistente';
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      inputFormatters: [phoneFormatter],
      focusNode: _phoneFocus,
      decoration: const InputDecoration(
        labelText: 'Telefone',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Por favor, insira seu telefone' : null,
    );
  }

  Widget _buildServiceField() {
    return TextFormField(
      controller: _serviceController,
      focusNode: _serviceFocus,
      decoration: const InputDecoration(
        labelText: 'Serviço Oferecido',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Por favor, informe o serviço' : null,
    );
  }

  Widget _buildCepField() {
    return TextFormField(
      focusNode: _cepFocus,
      controller: _cepController,
      inputFormatters: [cepFormatter],
      decoration: const InputDecoration(
        labelText: 'CEP',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) => value?.isEmpty ?? true ? 'CEP é obrigatório' : null,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      focusNode: _addressFocus,
      decoration: const InputDecoration(
        labelText: 'Endereço',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Por favor, insira seu endereço' : null,
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      controller: _cityController,
      focusNode: _cityFocus,
      decoration: const InputDecoration(
        labelText: 'Cidade',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Por favor, insira sua cidade' : null,
    );
  }

  Widget _buildUfField() {
    return TextFormField(
      controller: _ufController,
      focusNode: _ufFocus,
      decoration: const InputDecoration(
        labelText: 'Estado (UF)',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty)
          return 'Por favor, insira seu estado';
        if (value.length != 2) return 'UF deve ter 2 caracteres';
        return null;
      },
    );
  }

  Widget _buildContinueButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          final args = ValidateEmailArguments(
            name: _nameController.text,
            surname: _surnameController.text,
            cpf: _cpfController.text,
            cep: _cepController.text,
            city: _cityController.text,
            phone: _phoneController.text,
            uf: _ufController.text,
            address: _addressController.text,
            service: _serviceController.text,
            userType: widget.userType,
          );

          context.push(
            ValidateEmailPage.routeName,
            extra: args.toJson(),
          );
        }
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFfa7f3b),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "Continuar",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
