import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/features/login/data/datasources/authenticate_datasource.dart';
import 'package:profind/features/login/data/datasources/authenticate_datasource_impl.dart';
import 'package:profind/features/login/data/repositories/authenticate_repository_impl.dart';
import 'package:profind/features/login/domain/repositories/authenticate_repository.dart';
import 'package:profind/features/login/domain/usecase/authenticate_usecase.dart';
import 'package:provider/provider.dart';

sealed class LoginInject {
  static final List<Provider> providers = [
    Provider<FirebaseAuth>(
      create: (_) => FirebaseAuth.instance,
    ),
    Provider<AuthenticationDataSource>(
      create: (context) => AuthenticationDataSourceImpl(
        auth: context.read<FirebaseAuth>(),
      ),
    ),
    Provider<AuthenticateRepository>(
      create: (context) =>
          AuthenticateRepositoryImpl(auth: context.read<FirebaseAuth>()),
    ),
    Provider<AuthenticateUseCase>(
      create: (context) => AuthenticateUseCase(
        repository: context.read<AuthenticateRepository>(),
      ),
    ),
  ];
}
