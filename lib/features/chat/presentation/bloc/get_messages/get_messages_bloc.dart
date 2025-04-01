import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:profind/features/chat/domain/entities/chat_entity.dart';
import 'package:profind/features/chat/domain/entities/message_entity.dart';
import 'package:profind/features/chat/domain/usecase/get_messages_usecase.dart';

part 'get_messages_event.dart';
part 'get_messages_state.dart';

class GetMessagesBloc extends Bloc<GetMessagesEvent, GetMessagesState> {
  final GetMessagesUsecase _getMessagesUsecase;
  StreamSubscription? _messagesSubscription;

  GetMessagesBloc({required GetMessagesUsecase getMessagesUsecase})
      : _getMessagesUsecase = getMessagesUsecase,
        super(GetMessagesInitial()) {
    on<LoadMessages>(_onLoadMessages);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<GetMessagesState> emit,
  ) async {
    _messagesSubscription?.cancel();
    emit(GetMessagesLoading());

    _messagesSubscription = _getMessagesUsecase(event.chatId).listen(
      (tuple) {
        final (failure, messages) = tuple;

        if (failure != null) {
          emit(GetMessagesError(message: failure.toString()));
        } else
          emit(GetMessagesSuccess(messages: messages));
      },
      onError: (error) {
        emit(GetMessagesError(
          message: error.toString(),
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
