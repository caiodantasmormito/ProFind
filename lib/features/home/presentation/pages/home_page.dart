import 'package:flutter/material.dart';
import 'package:profind/features/client/presentation/pages/client_home_page.dart';
import 'package:profind/features/home/core/user_type_check.dart';
import 'package:profind/features/service_providers/presentation/pages/service_provider_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    UserTypeChecker(
      clientHome: const ClientHomePage(),
      serviceProviderHome: const ServiceProviderHomePage(),
    ),
    UserTypeChecker(
      clientHome: const ClientHomePage(),
      serviceProviderHome: const ServiceProviderHomePage(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(31),
          topLeft: Radius.circular(31),
        ),
        child: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          backgroundColor: Color(0xFFfa7f3b),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Color(0xFFE9E9E9),
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
