import 'package:go_router/go_router.dart';
import 'package:profind/features/chat/core/chat_routes.dart';
import 'package:profind/features/home/core/home_routes.dart';
import 'package:profind/features/login/core/authenticate_routes.dart';
import 'package:profind/features/login/presentation/pages/login_page.dart';
import 'package:profind/features/registration/core/registration_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoRouter router(SharedPreferences preferences) {
  return GoRouter(
    initialLocation: LoginPage.routeName,
    routes: [
      ...AuthenticateRoutes.routes,
      ...HomeRoutes.routes,
      ...RegistrationRoutes.routes,
      ...ChatRoutes.routes,
      
    ],
  );
}
