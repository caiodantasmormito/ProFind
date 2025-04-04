import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:profind/arguments/validate_email_arguments.dart';
import 'package:profind/features/address/presentation/bloc/get_address_bloc.dart';
import 'package:profind/features/registration/presentation/pages/email_registraion_page.dart';

class AddressRegistrationPage extends StatefulWidget {
  const AddressRegistrationPage(
      {super.key,
      required this.userType,
      required this.name,
      required this.surname,
      required this.cpf,
      required this.phone,
      this.service});

  static const routeName = '/registrationAddress';
  final String userType;
  final String name;
  final String surname;
  final String cpf;
  final String phone;
  final List<String>? service;

  @override
  State<AddressRegistrationPage> createState() =>
      _AddressRegistrationPageState();
}

class _AddressRegistrationPageState extends State<AddressRegistrationPage> {
  late final GetAddressBloc _addressBloc;

  late final GlobalKey<FormState> _formKey;

  late final TextEditingController _cityController;
  late final TextEditingController _cepController;
  late final TextEditingController _ufController;
  late final TextEditingController _addressController;
  late final TextEditingController _neighborhoodController;

  late final FocusNode _cepFocus;
  late final FocusNode _addressFocus;
  late final FocusNode _ufFocus;
  late final FocusNode _cityFocus;
  late final FocusNode _neighborhoodFocus;

  final cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp('[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeFocusNodes();
    _formKey = GlobalKey<FormState>();
    _addressBloc = GetAddressBloc(useCase: context.read());

    _cepController.addListener(_onCepChanged);
  }

  void _initializeControllers() {
    _cityController = TextEditingController();
    _ufController = TextEditingController();
    _neighborhoodController = TextEditingController();

    _cepController = TextEditingController();
    _addressController = TextEditingController();
  }

  void _initializeFocusNodes() {
    _ufFocus = FocusNode();
    _cityFocus = FocusNode();
    _cepFocus = FocusNode();
    _addressFocus = FocusNode();
    _neighborhoodFocus = FocusNode();
  }

  @override
  void dispose() {
    _addressController.dispose();

    _cityController.dispose();
    _ufController.dispose();
    _cepController.dispose();
    _neighborhoodController.dispose();

    _cepFocus.dispose();
    _addressFocus.dispose();
    _cityFocus.dispose();
    _ufFocus.dispose();
    _neighborhoodFocus.dispose();

    _cepController.removeListener(_onCepChanged);
    _addressBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Endereço'),
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
                  _buildCepField(),
                  _buildAddressField(),
                  _buildNeighborhoodField(),
                  _buildCityField(),
                  _buildUfField(),
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

  void _onCepChanged() {
    final cep = _cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length == 8) {
      _addressBloc.add(Address(cep: cep));
    }
  }

  Widget _buildCepField() {
    return BlocListener<GetAddressBloc, GetAddressState>(
      bloc: _addressBloc,
      listener: (context, state) {
        if (state is GetAddressSuccess) {
          _cityController.text = state.address.cidade;
          _ufController.text = state.address.uf;
          _addressController.text = state.address.logradouro;
          _neighborhoodController.text = state.address.bairro;
        } else if (state is GetAddressError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: TextFormField(
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
        validator: (value) =>
            value?.isEmpty ?? true ? 'CEP é obrigatório' : null,
      ),
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

  Widget _buildNeighborhoodField() {
    return TextFormField(
      controller: _neighborhoodController,
      focusNode: _neighborhoodFocus,
      enabled: true,
      decoration: const InputDecoration(
        labelText: 'Bairro',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira seu bairro';
        }

        return null;
      },
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      controller: _cityController,
      focusNode: _cityFocus,
      readOnly: true,
      enabled: false,
      decoration: const InputDecoration(
        labelText: 'Cidade',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        fillColor: Color(0xFFE0E0E0),
        filled: true,
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Por favor, insira sua cidade' : null,
    );
  }

  Widget _buildUfField() {
    return TextFormField(
      controller: _ufController,
      focusNode: _ufFocus,
      readOnly: true,
      enabled: false,
      decoration: const InputDecoration(
        labelText: 'Estado (UF)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        fillColor: Color(0xFFE0E0E0),
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira seu estado';
        }
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
            name: widget.name,
            surname: widget.surname,
            cpf: widget.cpf,
            cep: _cepController.text,
            city: _cityController.text,
            phone: widget.phone,
            uf: _ufController.text,
            address: _addressController.text,
            service: widget.userType == 'service_provider'
                ? widget.service!.join(', ')
                : '',
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
