part of 'get_service_providers_bloc.dart';

sealed class GetServiceProvidersState extends Equatable {
  const GetServiceProvidersState();

  @override
  List<Object?> get props => [];
}

class GetServiceProvidersInitial extends GetServiceProvidersState {}

final class GetServiceProvidersLoading extends GetServiceProvidersState {}

final class GetServiceProvidersError extends GetServiceProvidersState {
  final String? message;

  const GetServiceProvidersError({required this.message});
}

final class GetServiceProvidersSuccess extends GetServiceProvidersState {
  const GetServiceProvidersSuccess({required this.data});
  final List<ServiceProviderEntity> data;
  @override
  List<Object> get props => [data];
}
