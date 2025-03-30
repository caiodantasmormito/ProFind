import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profind/config/routes/routes.dart';
import 'package:profind/config/themes/dark_theme.dart';
import 'package:profind/config/themes/light_theme.dart';
import 'package:profind/core/infra/http_client.dart';
import 'package:profind/features/address/core/get_address_provider.dart';
import 'package:profind/features/login/core/authenticate_provider.dart';
import 'package:profind/features/messages/core/messages_provider.dart';
import 'package:profind/features/registration/core/registration_provider.dart';
import 'package:profind/features/service_providers/core/service_providers_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppWidget extends StatelessWidget {
  final SharedPreferences preferences;
  const AppWidget({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          Provider(
            create: (_) => HttpClient(),
          ),
          Provider<SharedPreferences>(
            create: (context) => preferences,
          ),
          Provider(
            create: (context) => AuthenticatedClient(
              sharedPreferences: context.read<SharedPreferences>(),
            ),
          ),
          ...LoginInject.providers,
          ...RegistrationInject.providers,
          ...MessagesInject.providers,
          ...AddressInject.providers,
          ...ServiceProvidersInject.providers,
        ],
        child: MaterialApp.router(
          title: 'ProFind',
          debugShowCheckedModeBanner: false,
          routerConfig: router(preferences),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
        ));
  }
}
