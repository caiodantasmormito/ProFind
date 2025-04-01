part of 'get_chats_bloc.dart';
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
  final List<String> chatId;

  const GetChatSuccess({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class GetChatError extends GetChatState {
  final String message;

  const GetChatError({required this.message});

  @override
  List<Object> get props => [message];
}