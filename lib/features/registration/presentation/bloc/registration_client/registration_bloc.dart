import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:profind/features/registration/domain/entities/user_entity.dart';
import 'package:profind/features/registration/domain/usecases/registration_usecase.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegistrationUsecase useCase;

  RegistrationBloc({required this.useCase}) : super(RegistrationInitial()) {
    on<RegisterUserEvent>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());

    final (failure, user) = await useCase(event.params);

    if (failure != null) {
      emit(RegistrationError(
        message: failure.message!,
      ));
    } else if (user != null) {
      emit(RegistrationSuccess(user: user));
    }
  }
}
