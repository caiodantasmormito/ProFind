/*part of 'registration_service_provider_bloc.dart';


sealed class RegistrationServiceProviderState extends Equatable {
  const RegistrationServiceProviderState();

  @override
  List<Object?> get props => [];
}

final class RegistrationServiceProviderInitial extends RegistrationServiceProviderState {
  const RegistrationServiceProviderInitial();
}

final class RegistrationServiceProviderLoading extends RegistrationServiceProviderState {
  const RegistrationServiceProviderLoading();
}

final class RegistrationServiceProviderError extends RegistrationServiceProviderState {
  const RegistrationServiceProviderError({this.message});
  final String? message;

  @override
  List<Object?> get props => [message];
}

final class RegistrationServiceProviderSuccess extends RegistrationServiceProviderState {
  const RegistrationServiceProviderSuccess({required this.data});
  final ServiceProviderEntity data;
  @override
  List<Object?> get props => [data];
}
*/