import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 16),
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

                return nameMatch || serviceMatch;
              }).toList();

              filteredContacts.sort((a, b) => _isAscending
                  ? a.name.compareTo(b.name)
                  : b.name.compareTo(a.name));

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          decoration: InputDecoration(
                            hintText: 'Pesquisar por nome ou profissão',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.search),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchText = value;
                            });
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
                  SizedBox(height: 16),
                  Expanded(
                    child: filteredContacts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.contact_mail_outlined,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                const Text(
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
                                    onPressed: () {},
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
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
