part of 'registration_client_bloc.dart';


sealed class RegistrationClientState extends Equatable {
  const RegistrationClientState();

  @override
  List<Object?> get props => [];
}

final class RegistrationClientInitial extends RegistrationClientState {
  const RegistrationClientInitial();
}

final class RegistrationClientLoading extends RegistrationClientState {
  const RegistrationClientLoading();
}

final class RegistrationClientError extends RegistrationClientState {
  const RegistrationClientError({this.message});
  final String? message;

  @override
  List<Object?> get props => [message];
}

final class RegistrationClientSuccess extends RegistrationClientState {
  const RegistrationClientSuccess({required this.data});
  final ClientEntity data;
  @override
  List<Object?> get props => [data];
}
