part of 'get_or_create_chat_bloc.dart';
abstract class GetChatState extends Equatable {
  const GetChatState();
}

class GetChatInitial extends GetChatState {
  @override
  List<Object> get props => [];
}

class GetChatLoading extends GetChatState {
  @override
  List<Object> get props => [];
}

class GetChatSuccess extends GetChatState {
  final String chatId;
  final List<MessageEntity> messages;

  const GetChatSuccess({required this.chatId, required this.messages});

  @override
  List<Object> get props => [chatId, messages];
}

class GetChatError extends GetChatState {
  final String message;

  const GetChatError({required this.message});

  @override
  List<Object> get props => [message];
}