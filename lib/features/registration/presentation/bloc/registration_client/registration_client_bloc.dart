import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:profind/features/registration/domain/entities/client_entity.dart';
import 'package:profind/features/registration/domain/usecases/registration_client_usecase.dart';

part 'registration_client_event.dart';
part 'registration_client_state.dart';

class RegistrationClientBloc
    extends Bloc<RegistrationClientEvent, RegistrationClientState> {
  final RegistrationClientUsecase useCase;
  RegistrationClientBloc({required this.useCase})
      : super(RegistrationClientInitial()) {
    on<RegistrationClient>((event, emit) async {
      emit(RegistrationClientLoading());
      final (failure, client) = await useCase(event.params);
      if (failure == null) {
        emit(RegistrationClientSuccess(data: client!));
      } else {
        final errorMessage = failure is RegistrationClientError &&
                failure.message == 'CPF já cadastrado'
            ? 'Já existe um contato com este CPF'
            : failure.message;
        emit(RegistrationClientError(message: errorMessage));
      }
    });
  }
}
