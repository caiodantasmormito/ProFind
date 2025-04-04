import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/arguments/validate_email_arguments.dart';
import 'package:profind/features/registration/domain/usecases/registration_usecase.dart';
import 'package:profind/features/registration/presentation/bloc/registration/registration_bloc.dart';
import 'package:profind/features/registration/presentation/bloc/verify_email/verify_email_bloc.dart';
import 'package:profind/features/registration/presentation/pages/address_registration_page.dart';
import 'package:profind/features/registration/presentation/pages/email_registraion_page.dart';
import 'package:profind/features/registration/presentation/pages/personal_info_registration_page.dart';
import 'package:profind/features/registration/presentation/pages/verification_email_page.dart';

sealed class RegistrationRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: RegistrationPage.routeName,
      builder: (context, state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return RegistrationPage(
          userType: args['userType'] as String,
        );
      },
    ),
    GoRoute(
      path: AddressRegistrationPage.routeName,
      builder: (context, state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return AddressRegistrationPage(
          name: args['name'] as String,
          surname: args['surname'] as String,
          cpf: args['cpf'] as String,
          phone: args['phone'] as String,
          userType: args['userType'] as String,
          service: List<String>.from(args['services'] ?? []),
        );
      },
    ),
    GoRoute(
      path: ValidateEmailPage.routeName,
      builder: (context, state) {
        final Map<String, dynamic> arguments =
            state.extra as Map<String, dynamic>;
        return BlocProvider<RegistrationBloc>(
          create: (context) => RegistrationBloc(
            useCase: context.read<RegistrationUsecase>(),
          ),
          child: ValidateEmailPage(
            arguments: ValidateEmailArguments.fromJson(arguments),
            userType: arguments['userType'] as String,
          ),
        );
      },
    ),
    GoRoute(
      path: EmailVerificationPage.routeName,
      builder: (context, state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return BlocProvider<EmailVerificationBloc>(
          create: (context) => EmailVerificationBloc(),
          child: EmailVerificationPage(
            userId: args['userId'] as String,
            email: args['email'] as String,
          ),
        );
      },
    ),
  ];
}
