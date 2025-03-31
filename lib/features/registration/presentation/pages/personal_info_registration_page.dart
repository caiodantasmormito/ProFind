import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:profind/arguments/validate_email_arguments.dart';
import 'package:profind/features/registration/presentation/pages/email_registraion_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.userType});

  static const routeName = '/registration';
  final String userType;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final List<String> _selectedServices = [];
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

  final List<String> suggestedServices = [
    'Encanador',
    'Eletricista',
    'Pedreiro',
    'Jardineiro',
    'Motorista particular',
    'Pintor',
    'Marceneiro',
    'Técnico em ar condicionado',
    'Diarista',
    'Cuidador de idosos',
    'Babá',
    'Personal trainer',
    'Técnico em informática',
    'Manicure',
    'Cabeleireiro',
    'Serralheiro',
    'Azulejista'
        'Freteiro',
    'Barman'
  ];

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
    _selectedServices.clear();
    _nameController.dispose();
    _surnameController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _ufController.dispose();
    _cepController.dispose();
    _serviceController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _cpfFocus.dispose();
    _cepFocus.dispose();
    _addressFocus.dispose();
    _cityFocus.dispose();
    _ufFocus.dispose();
    _surnameFocus.dispose();
    _serviceFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(widget.userType == 'client'
            ? 'Cadastro de Cliente'
            : 'Cadastro de Prestador'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      focusNode: _nameFocus,
      decoration: const InputDecoration(
        labelText: 'Nome',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Por favor, insira seu telefone' : null,
    );
  }

  Widget _buildServiceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return suggestedServices.where((String option) {
              return option
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            setState(() {
              if (!_selectedServices.contains(selection)) {
                _selectedServices.add(selection);
                _serviceController.clear();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _serviceFocus.requestFocus();
                });
              }
            });
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  color: Colors.white,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Serviço Oferecido',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onFieldSubmitted: (value) {
                if (value.isNotEmpty && !_selectedServices.contains(value)) {
                  setState(() {
                    _selectedServices.add(value);
                    textEditingController.clear();
                  });
                }
              },
              validator: (value) => _selectedServices.isEmpty
                  ? 'Por favor, informe pelo menos um serviço'
                  : null,
            );
          },
        ),
        const SizedBox(height: 8),
        if (_selectedServices.isNotEmpty) ...[
          const Text(
            'Serviços selecionados:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _selectedServices.map((service) {
              return Chip(
                label: Text(
                  service,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color(0xFFfa7f3b),
                deleteIcon:
                    const Icon(Icons.close, size: 18, color: Colors.white),
                onDeleted: () {
                  setState(() {
                    _selectedServices.remove(service);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildCepField() {
    return TextFormField(
      focusNode: _cepFocus,
      controller: _cepController,
      inputFormatters: [cepFormatter],
      decoration: const InputDecoration(
        labelText: 'CEP',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
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
            service: widget.userType == 'service_provider'
                ? _selectedServices.join(', ')
                : _serviceController.text,
            userType: widget.userType,
          );

          context.go(
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
