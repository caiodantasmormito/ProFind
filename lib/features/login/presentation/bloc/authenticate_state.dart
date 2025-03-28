part of 'authenticate_bloc.dart';

sealed class AuthenticateState extends Equatable {
  const AuthenticateState();

  @override
  List<Object?> get props => [];
}

class AuthenticateInitial extends AuthenticateState {}

class AuthenticateLoading extends AuthenticateState {}

class AuthenticateError extends AuthenticateState {
  final String message;
  const AuthenticateError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthenticateSuccess extends AuthenticateState {
  final User user;
  const AuthenticateSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}