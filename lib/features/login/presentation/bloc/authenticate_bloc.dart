import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/features/login/domain/usecase/authenticate_usecase.dart';

part 'authenticate_event.dart';
part 'authenticate_state.dart';

class AuthenticateBloc extends Bloc<AuthenticateEvent, AuthenticateState> {
  final AuthenticateUseCase useCase;
  

  AuthenticateBloc({required this.useCase}) : super(AuthenticateInitial()) {
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onLogin(
      LoginEvent event, Emitter<AuthenticateState> emit) async {
    emit(AuthenticateLoading());
    try {
      final (failure, user) = await useCase(event.params);

      if (failure != null) {
        emit(AuthenticateError(message: failure.message!));
        return;
      }
    

      emit(AuthenticateSuccess(user: user!));
    } catch (e) {
      emit(AuthenticateError(message: e.toString()));
    }
  }
}
