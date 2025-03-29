import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:profind/features/registration/domain/entities/service_provider_entity.dart';
import 'package:profind/features/registration/domain/usecases/registration_client_usecase.dart';
import 'package:profind/features/registration/domain/usecases/registration_service_provider_usecase.dart';

part 'registration_service_provider_event.dart';
part 'registration_service_provider_state.dart';

class RegistrationServiceProviderBloc extends Bloc<
    RegistrationServiceProviderEvent, RegistrationServiceProviderState> {
  final RegistrationServiceProviderUsecase useCase;
  RegistrationServiceProviderBloc({required this.useCase})
      : super(RegistrationServiceProviderInitial()) {
    on<RegistrationServiceProvider>((event, emit) async {
      emit(RegistrationServiceProviderLoading());
      final (failure, client) = await useCase(event.params);
      if (failure == null) {
        emit(RegistrationServiceProviderSuccess(data: client!));
      } else {
        final errorMessage = failure is RegistrationServiceProviderError &&
                failure.message == 'CPF já cadastrado'
            ? 'Já existe um contato com este CPF'
            : failure.message;
        emit(RegistrationServiceProviderError(message: errorMessage));
      }
    });
  }
}
