import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/features/client/presentation/pages/client_home_page.dart';
import 'package:profind/features/home/presentation/pages/new_home_page.dart';
import 'package:profind/features/service_providers/domain/usecases/get_service_providers_usecase.dart';
import 'package:profind/features/service_providers/presentation/bloc/get_service_providers_bloc.dart';

sealed class HomeRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: HomePage.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<GetServiceProvidersBloc>(
            create: (context) => GetServiceProvidersBloc(
              useCase: context.read<GetServiceProvidersUsecase>(),
            ),
          ),
        ],
        child: const HomePage(),
      ),
    ),
   
    GoRoute(
      path: ClientHomePage.routeName,
      builder: (context, state) => const ClientHomePage(),
    ),
  ];
}
