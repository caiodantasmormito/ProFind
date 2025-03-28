import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profind/features/messages/domain/entities/messages_entity.dart';
import 'package:profind/features/messages/domain/usecase/send_message_usecase.dart';


part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final SendMessageUsecase useCase;
  SendMessageBloc({required this.useCase}) : super(SendMessageInitial()) {
    on<SendMessage>((event, emit) async {
      emit(SendMessageLoading());

      final (failure, _) = await useCase(event.params);

      if (failure == null) {
        emit(SendMessageSuccess());
      } else {        
        emit(SendMessageError(message: failure.message));
      }
    });
  }
}
