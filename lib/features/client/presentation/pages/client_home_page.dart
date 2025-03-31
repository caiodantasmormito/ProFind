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
  final String _searchText = '';

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
      body: BlocConsumer<GetServiceProvidersBloc, GetServiceProvidersState>(
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
              return serviceProvider.name.toLowerCase().contains(_searchText) ||
                  serviceProvider.cpf.contains(_searchText);
            }).toList();

            if (filteredContacts.isNotEmpty) {
              return ListView.builder(
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  final serviceProvider = filteredContacts[index];
                  return InkWell(
                    onTap: () {},
                    child: Card(
                      elevation: 3,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: MediaQuery.of(context).size.height * 0.002),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          serviceProvider.name,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serviceProvider.service.join(','),
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
                    ),
                  );
                },
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 1),
                  const Icon(
                    Icons.contact_mail_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const Text(
                    'Nenhum contato disponível',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          }
          return SafeArea(child: Text('HOME PAGE'));
        },
      ),
    );
  }
}
