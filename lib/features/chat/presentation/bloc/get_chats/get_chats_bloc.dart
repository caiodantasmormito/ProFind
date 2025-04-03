import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/chat/domain/entities/message_entity.dart';
import 'package:profind/features/chat/domain/usecase/get_messages_usecase.dart';
import 'package:profind/features/chat/domain/usecase/get_or_create_chat_usecase.dart';
import 'package:profind/features/chat/domain/usecase/send_message_usecase.dart';

part 'get_chats_event.dart';
part 'get_chats_state.dart';

class ChatBloc extends Bloc<GetChatEvent, GetChatState> {
  final GetOrCreateChatUsecase _getOrCreateChat;
  final SendMessageUsecase _sendMessage;
  final GetMessagesUsecase _getMessages;

  ChatBloc({
    required GetOrCreateChatUsecase getOrCreateChat,
    required SendMessageUsecase sendMessage,
    required GetMessagesUsecase getMessages,
  })  : _getOrCreateChat = getOrCreateChat,
        _sendMessage = sendMessage,
        _getMessages = getMessages,
        super(GetChatInitial()) {
    on<InitializeChat>(_onInitializeChat);
    on<NewSendMessage>(_onSendMessage);
  }

  Future<void> _onInitializeChat(
    InitializeChat event,
    Emitter<GetChatState> emit,
  ) async {
    emit(GetChatLoading());
    try {
      final (failure, chatId) = await _getOrCreateChat(CreateChatParams(
        clientId: event.clientId,
        providerId: event.providerId,
      ));

      if (failure != null || chatId == null) {
        throw Exception(failure?.message ?? 'Failed to create chat');
      }

      await emit.forEach<(Failure?, List<MessageEntity>)>(
        _getMessages(chatId),
        onData: (result) {
          final (failure, messages) = result;
          if (failure != null) throw Exception(failure.message);
          return GetChatSuccess(chatId: chatId, messages: messages);
        },
        onError: (error, _) => GetChatError(message: error.toString()),
      );
    } catch (e) {
      emit(GetChatError(message: e.toString()));
    }
  }

  Future<void> _onSendMessage(
    NewSendMessage event,
    Emitter<GetChatState> emit,
  ) async {
    if (state is! GetChatSuccess) return;

    try {
      final (failure, _) = await _sendMessage(SendMessageParams(
        chatId: event.chatId,
        senderId: event.senderId,
        text: event.text,
      ));

      if (failure != null) {
        throw Exception(failure.message);
      }
    } catch (e) {
      emit(GetChatError(message: e.toString()));
      
      if (state is GetChatSuccess) {
        emit(state as GetChatSuccess);
      }
    }
  }
}
