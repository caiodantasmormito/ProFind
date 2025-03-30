part of 'get_service_providers_bloc.dart';

sealed class GetServiceProvidersEvent extends Equatable {
  const GetServiceProvidersEvent();
}

final class GetServiceProviders extends GetServiceProvidersEvent {
  const GetServiceProviders();

  @override
  List<Object?> get props => [];
}
