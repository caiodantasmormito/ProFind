import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profind/arguments/validate_email_arguments.dart';
import 'package:profind/features/registration/domain/usecases/registration_usecase.dart';
import 'package:profind/features/registration/presentation/bloc/registration/registration_bloc.dart';
import 'package:profind/features/registration/presentation/bloc/verify_email/verify_email_bloc.dart';
import 'package:profind/features/registration/presentation/pages/registration_personal_info_page.dart';
import 'package:profind/features/registration/presentation/pages/validate_email_page.dart';
import 'package:profind/features/registration/presentation/pages/verification_email_page.dart';

sealed class RegistrationRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: RegistrationPage.routeName,
      builder: (context, state) {
        return RegistrationPage(
          userType: '',
        );
      },
    ),
    GoRoute(
      path: ValidateEmailPage.routeName,
      builder: (context, state) {
        final arguments = state.extra as Map<String, dynamic>;
        return BlocProvider<RegistrationBloc>(
          create: (context) => RegistrationBloc(
            useCase: context.read<RegistrationUsecase>(),
          ),
          child: ValidateEmailPage(
            arguments: ValidateEmailArguments.fromJson(arguments),
            userType: '',
          ),
        );
      },
    ),
    GoRoute(
      path: EmailVerificationPage.routeName,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return BlocProvider<EmailVerificationBloc>(
          create: (context) => EmailVerificationBloc(
              //useCase: context.read<RegistrationUsecase>(),
              ),
          child: EmailVerificationPage(
            userId: args['userId'],
            email: args['email'],
          ),
        );
      },
    ),
  ];
}
