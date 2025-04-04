import 'package:go_router/go_router.dart';
import 'package:profind/features/profile/presentation/pages/profile_page.dart';

sealed class ProfileRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: ProfilePage.routeName,
      builder: (context, state) => const ProfilePage(),
    ),
  ];
}
