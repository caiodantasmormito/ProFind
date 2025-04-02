import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:profind/features/chat/domain/entities/message_entity.dart';
import 'package:profind/features/chat/domain/usecase/get_messages_usecase.dart';

part 'get_messages_event.dart';
part 'get_messages_state.dart';

class GetMessagesBloc extends Bloc<GetMessagesEvent, GetMessagesState> {
  final GetMessagesUsecase _getMessagesUsecase;
  StreamSubscription? _messagesSubscription;
  bool _isStreamActive = false;

  GetMessagesBloc({required GetMessagesUsecase getMessagesUsecase})
      : _getMessagesUsecase = getMessagesUsecase,
        super(GetMessagesInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<MessagesFailed>(_onMessagesFailed);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<GetMessagesState> emit,
  ) async {
    await _messagesSubscription?.cancel();
    _isStreamActive = false;

    emit(GetMessagesLoading());

    try {
      _messagesSubscription = _getMessagesUsecase(event.chatId).listen(
        (tuple) {
          if (!_isStreamActive || isClosed) return;

          final (failure, messages) = tuple;

          if (failure != null) {
            add(MessagesFailed(message: failure.toString()));
          } else {
            add(MessagesUpdated(messages: messages));
          }
        },
        onError: (error) {
          if (!isClosed) {
            add(MessagesFailed(message: error.toString()));
          }
        },
        cancelOnError: false,
      );

      _isStreamActive = true;
    } catch (e) {
      if (!isClosed) {
        emit(GetMessagesError(
            message: 'Failed to load messages: ${e.toString()}'));
      }
    }
  }

  void _onMessagesUpdated(
      MessagesUpdated event, Emitter<GetMessagesState> emit) {
    emit(GetMessagesSuccess(messages: event.messages));
  }

  void _onMessagesFailed(MessagesFailed event, Emitter<GetMessagesState> emit) {
    emit(GetMessagesError(message: event.message));
  }

  @override
  Future<void> close() {
    _isStreamActive = false;
    _messagesSubscription?.cancel();
    return super.close();
  }
}
