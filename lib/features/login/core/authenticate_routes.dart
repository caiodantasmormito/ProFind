import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/features/login/domain/usecase/authenticate_usecase.dart';
import 'package:profind/features/login/presentation/bloc/authenticate_bloc.dart';
import 'package:profind/features/login/presentation/pages/login_page.dart';

sealed class AuthenticateRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: LoginPage.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticateBloc>(
            create: (context) => AuthenticateBloc(
              useCase: context.read<AuthenticateUseCase>(),
            ),
          ),
        ],
        child: const LoginPage(),
      ),
    ),
  ];
}
