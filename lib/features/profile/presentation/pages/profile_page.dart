import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profind/features/profile/presentation/bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const String routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('Meu Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFFfa7f3b)),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }

          if (state is ProfileLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFFfa7f3b),
                          child:
                              Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${user.name} ${user.surname}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.userType == 'service_provider'
                              ? 'Prestador de Serviços'
                              : 'Cliente',
                          style: const TextStyle(
                            color: Color(0xFFfa7f3b),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildInfoSection(
                    title: 'Informações Pessoais',
                    children: [
                      _buildInfoItem(
                        icon: Icons.email,
                        label: 'Email',
                        value: user.email,
                      ),
                      _buildInfoItem(
                        icon: Icons.badge,
                        label: 'CPF',
                        value: user.cpf,
                      ),
                      _buildInfoItem(
                        icon: Icons.phone,
                        label: 'Telefone',
                        value: user.phone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInfoSection(
                    title: 'Endereço',
                    children: [
                      _buildInfoItem(
                        icon: Icons.location_on,
                        label: 'Logradouro',
                        value: user.address,
                      ),
                      _buildInfoItem(
                        icon: Icons.location_city,
                        label: 'Cidade',
                        value: '${user.city}/${user.uf}',
                      ),
                      _buildInfoItem(
                        icon: Icons.pin,
                        label: 'CEP',
                        value: user.cep,
                      ),
                    ],
                  ),
                  if (user.userType == 'service_provider') ...[
                    const SizedBox(height: 24),
                    _buildInfoSection(
                      title: 'Serviços',
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: user.service!
                              .split(', ')
                              .map((service) => Chip(
                                    label: Text(
                                      service,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: const Color(0xFFfa7f3b),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFfa7f3b)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
