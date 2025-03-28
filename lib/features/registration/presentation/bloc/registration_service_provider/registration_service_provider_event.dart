part of 'registration_service_provider_bloc.dart';

sealed class RegistrationServiceProviderEvent extends Equatable {
  const RegistrationServiceProviderEvent();
}

final class RegistrationServiceProvider extends RegistrationServiceProviderEvent {
  final ServiceProviderRegistrationParams params;
  const RegistrationServiceProvider({required this.params});

  @override
  List<Object?> get props => [params];
}
