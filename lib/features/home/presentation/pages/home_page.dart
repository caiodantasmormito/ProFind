import 'package:flutter/material.dart';
import 'package:profind/features/home/core/user_type_check.dart';
import 'package:profind/features/home/presentation/pages/client_home_page.dart';
import 'package:profind/features/service_providers/presentation/pages/service_provider_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return UserTypeChecker(
      clientHome: const ClientHomePage(),
      serviceProviderHome: const ServiceProviderHomePage(),
    );
  }
}
