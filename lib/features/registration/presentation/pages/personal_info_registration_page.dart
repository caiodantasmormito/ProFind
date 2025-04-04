import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:profind/features/address/presentation/bloc/get_address_bloc.dart';
import 'package:profind/features/registration/presentation/pages/address_registration_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.userType});

  static const routeName = '/registration';
  final String userType;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final GetAddressBloc _addressBloc;
  final List<String> _selectedServices = [];
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _cpfController;
  late final TextEditingController _phoneController;

  late final TextEditingController _serviceController;

  late final FocusNode _phoneFocus;
  late final FocusNode _nameFocus;
  late final FocusNode _cpfFocus;
  late final FocusNode _surnameFocus;

  late final FocusNode _serviceFocus;

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
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
    _addressBloc = GetAddressBloc(useCase: context.read());
  }

  void _initializeControllers() {
    _surnameController = TextEditingController();
    _nameController = TextEditingController();
    _cpfController = TextEditingController();

    _phoneController = TextEditingController();
    _serviceController = TextEditingController();
  }

  void _initializeFocusNodes() {
    _phoneFocus = FocusNode();
    _nameFocus = FocusNode();
    _cpfFocus = FocusNode();

    _surnameFocus = FocusNode();

    _serviceFocus = FocusNode();
  }

  @override
  void dispose() {
    _selectedServices.clear();
    _nameController.dispose();
    _surnameController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();

    _serviceController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _cpfFocus.dispose();

    _surnameFocus.dispose();
    _serviceFocus.dispose();

    _addressBloc.close();
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
      body: BlocProvider(
        create: (context) => _addressBloc,
        child: SingleChildScrollView(
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
                  if (widget.userType == 'service_provider')
                    _buildServiceField(),
                  const SizedBox(height: 24),
                  _buildContinueButton(),
                ],
              ),
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
        Row(
          children: [
            Expanded(
              child: Autocomplete<String>(
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
                  _addService(selection);
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
                    decoration: InputDecoration(
                      labelText: 'Serviço Oferecido',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          _serviceFocus.requestFocus();
                          _showServiceDropdown(context);
                        },
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty &&
                          !_selectedServices.contains(value)) {
                        _addService(value);
                      }
                    },
                    validator: (value) => _selectedServices.isEmpty
                        ? 'Por favor, informe pelo menos um serviço'
                        : null,
                  );
                },
              ),
            ),
          ],
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

  void _addService(String service) {
    setState(() {
      if (!_selectedServices.contains(service)) {
        _selectedServices.add(service);
        _serviceController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _serviceFocus.requestFocus();
        });
      }
    });
  }

  void _showServiceDropdown(BuildContext context) {
    final RenderBox textFieldRenderBox =
        context.findRenderObject() as RenderBox;
    final textFieldPosition = textFieldRenderBox.localToGlobal(Offset.zero);
    final textFieldWidth = textFieldRenderBox.size.width;

    showMenu(
      color: Colors.white,
      context: context,
      position: RelativeRect.fromLTRB(
        textFieldPosition.dx,
        textFieldPosition.dy + textFieldRenderBox.size.height,
        textFieldPosition.dx + textFieldWidth,
        textFieldPosition.dy + textFieldRenderBox.size.height + 200,
      ),
      items: suggestedServices.map((service) {
        return PopupMenuItem<String>(
          value: service,
          child: Text(service),
          onTap: () => _addService(service),
        );
      }).toList(),
    );
  }

  Widget _buildContinueButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          context.push(
            AddressRegistrationPage.routeName,
            extra: {
              'name': _nameController.text,
              'surname': _surnameController.text,
              'cpf': _cpfController.text,
              'phone': _phoneController.text,
              'userType': widget.userType,
              'services': widget.userType == 'service_provider'
                  ? _selectedServices
                  : [],
            },
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
