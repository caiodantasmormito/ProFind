part of 'registration_client_bloc.dart';

sealed class RegistrationClientEvent extends Equatable {
  const RegistrationClientEvent();
}

final class RegistrationClient extends RegistrationClientEvent {
  final RegistrationParams params;
  const RegistrationClient({required this.params});

  @override
  List<Object?> get props => [params];
}
