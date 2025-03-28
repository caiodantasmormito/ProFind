part of 'authenticate_bloc.dart';

sealed class AuthenticateEvent extends Equatable {
  const AuthenticateEvent();
}

final class LoginEvent extends AuthenticateEvent {
  final AuthenticateParams params;
  const LoginEvent(this.params);

  @override
  List<Object?> get props => [params];
}

