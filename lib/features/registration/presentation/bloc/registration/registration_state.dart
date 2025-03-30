part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final UserEntity user;

  const RegistrationSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class RegistrationError extends RegistrationState {
  final String message;

  const RegistrationError({required this.message});

  @override
  List<Object> get props => [message];
}