import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/features/chat/presentation/pages/chat_page.dart';
import 'package:profind/features/login/presentation/pages/login_page.dart';
import 'package:profind/features/service_providers/presentation/bloc/get_service_providers_bloc.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});
  static const String routeName = '/client';

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocus;
  String _searchText = '';
  bool _isAscending = true;
  final Set<String> _selectedProfessions = {};
  Set<String> _availableProfessions = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocus = FocusNode();
    context.read<GetServiceProvidersBloc>().add(GetServiceProviders());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _updateAvailableProfessions(List<dynamic> serviceProviders) {
    _availableProfessions = serviceProviders
        .expand((provider) => provider.service as List<String>)
        .toSet();
  }

  void _toggleProfession(String profession) {
    setState(() {
      if (_selectedProfessions.contains(profession)) {
        _selectedProfessions.remove(profession);
      } else {
        _selectedProfessions.add(profession);
      }
    });
    _searchController.clear();
  }

  List<String> _getSuggestions(String query) {
    return _availableProfessions
        .where((profession) =>
            profession.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<int>(
            color: Colors.white,
            icon: const Icon(Icons.menu, color: Colors.black),
            onSelected: (value) {
              if (value == 0) {
                FirebaseAuth.instance.signOut();
                context.pushReplacement(LoginPage.routeName);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Sair'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocConsumer<GetServiceProvidersBloc, GetServiceProvidersState>(
          listener: (context, state) {
            if (state is GetServiceProvidersError && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is GetServiceProvidersSuccess) {
              _updateAvailableProfessions(state.data);
            }
          },
          builder: (context, state) {
            if (state is GetServiceProvidersLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetServiceProvidersSuccess) {
              final filteredContacts = state.data.where((serviceProvider) {
                final nameMatch = serviceProvider.name
                    .toLowerCase()
                    .contains(_searchText.toLowerCase());

                final serviceMatch = serviceProvider.service.any((service) =>
                    service.toLowerCase().contains(_searchText.toLowerCase()));

                final professionMatch = _selectedProfessions.isEmpty ||
                    serviceProvider.service.any(
                        (service) => _selectedProfessions.contains(service));

                return (nameMatch || serviceMatch) && professionMatch;
              }).toList();

              filteredContacts.sort((a, b) => _isAscending
                  ? a.name.compareTo(b.name)
                  : b.name.compareTo(a.name));

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<String>.empty();
                            }
                            return _getSuggestions(textEditingValue.text);
                          },
                          onSelected: (String selection) {
                            _toggleProfession(selection);
                          },
                          fieldViewBuilder: (context, controller, focusNode,
                              onFieldSubmitted) {
                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                hintText: 'Digite ou selecione uma profissão',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    controller.clear();
                                    setState(() {
                                      _searchText = '';
                                    });
                                  },
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchText = value;
                                });
                              },
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                color: Colors.white,
                                elevation: 4,
                                child: Container(
                                  constraints:
                                      const BoxConstraints(maxHeight: 200),
                                  width: MediaQuery.of(context).size.width - 32,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final option = options.elementAt(index);
                                      return ListTile(
                                        leading: Icon(
                                          _selectedProfessions.contains(option)
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: const Color(0xFFfa7f3b),
                                        ),
                                        title: Text(option),
                                        onTap: () {
                                          onSelected(option);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isAscending ? Icons.sort_by_alpha : Icons.sort,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _isAscending = !_isAscending;
                          });
                        },
                      ),
                    ],
                  ),
                  if (_selectedProfessions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _selectedProfessions.map((profession) {
                        return Chip(
                          label: Text(
                            profession,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: const Color(0xFFfa7f3b),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.white,
                          ),
                          onDeleted: () => _toggleProfession(profession),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Expanded(
                    child: filteredContacts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.contact_mail_outlined,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Nenhum prestador de serviço encontrado',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredContacts.length,
                            itemBuilder: (context, index) {
                              final serviceProvider = filteredContacts[index];
                              return Card(
                                elevation: 3,
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.002),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.chat,
                                        color: Color(0xFFfa7f3b)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            providerId: serviceProvider.id!,
                                            providerName:
                                                '${serviceProvider.name} ${serviceProvider.surname}',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  title: Text(
                                    '${serviceProvider.name} '
                                    '${serviceProvider.surname}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        serviceProvider.service.join(', '),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Color(0xFFfa7f3b)),
                                      ),
                                      Text(
                                          '${serviceProvider.city}/${serviceProvider.uf}'),
                                      Text('Tel: ${serviceProvider.phone}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
