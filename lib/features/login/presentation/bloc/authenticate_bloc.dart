import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/features/login/domain/usecase/authenticate_usecase.dart';

part 'authenticate_event.dart';
part 'authenticate_state.dart';

class AuthenticateBloc extends Bloc<AuthenticateEvent, AuthenticateState> {
  final AuthenticateUseCase useCase;
  AuthenticateBloc({required this.useCase}) : super(AuthenticateInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthenticateLoading());
      final (failure, user) = await useCase(event.params);
      if (failure == null) {
        emit(AuthenticateSuccess(user: user!));

        return;
      }
      emit(AuthenticateError(message: failure.message.toString()));
    });
  }
}
