import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:profind/features/chat/domain/usecase/send_message_usecase.dart';

part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final SendMessageUsecase _sendMessageUsecase;

  SendMessageBloc({required SendMessageUsecase sendMessageUsecase})
      : _sendMessageUsecase = sendMessageUsecase,
        super(SendMessageInitial()) {
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<SendMessageState> emit,
  ) async {
    emit(SendMessageLoading());

    final (failure, _) = await _sendMessageUsecase(
      SendMessageParams(
        chatId: event.chatId,
        text: event.text,
        senderId: event.senderId,
      ),
    );

    if (failure != null) {
      emit(SendMessageError(message: failure.message));
    } else {
      emit(SendMessageSuccess());
    }
  }
}
