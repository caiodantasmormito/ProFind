import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/service_providers/domain/entities/service_provider_entity.dart';
import 'package:profind/features/service_providers/domain/usecases/get_service_providers_usecase.dart';


part 'get_service_providers_event.dart';
part 'get_service_providers_state.dart';

class GetServiceProvidersBloc extends Bloc<GetServiceProvidersEvent, GetServiceProvidersState> {
  final GetServiceProvidersUsecase useCase;
  GetServiceProvidersBloc({required this.useCase}) : super(GetServiceProvidersInitial()) {
    on<GetServiceProviders>((event, emit) async {
      emit(GetServiceProvidersLoading());
      final (failure, result) = await useCase(NoParams());

      if (failure == null) {
        emit(GetServiceProvidersSuccess(data: result!));
      } else {
        emit(GetServiceProvidersError(message: failure.message));
      }
    });
    
  }
  
}
