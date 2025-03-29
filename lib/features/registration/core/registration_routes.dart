import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/arguments/validate_email_arguments.dart';
import 'package:profind/features/registration/domain/usecases/registration_client_usecase.dart';
import 'package:profind/features/registration/presentation/bloc/registration_client/registration_client_bloc.dart';
import 'package:profind/features/registration/presentation/pages/registration_personal_info_page.dart';
import 'package:profind/features/registration/presentation/pages/validate_email_page.dart';

sealed class RegistrationRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: ClientRegistrationPage.routeName,
      builder: (context, state) {
        return ClientRegistrationPage(
          userType: '',
        );
      },
    ),
    GoRoute(
      path: ValidateEmailPage.routeName,
      builder: (context, state) {
        final arguments = state.extra as Map<String, dynamic>;
        return BlocProvider<RegistrationClientBloc>(
          create: (context) => RegistrationClientBloc(
            useCase: context.read<RegistrationClientUsecase>(),
          ),
          child: ValidateEmailPage(
            arguments: ValidateEmailArguments.fromJson(arguments),
          ),
        );
      },
    ),
  ];
}
