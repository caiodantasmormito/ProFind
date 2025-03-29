part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserEvent extends RegistrationEvent {
  final RegistrationParams params;

  const RegisterUserEvent(this.params);

  @override
  List<Object> get props => [params];
}