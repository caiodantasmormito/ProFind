part of 'get_messages_bloc.dart';

sealed class GetMessagesEvent extends Equatable {
  const GetMessagesEvent();
}

final class LoadMessages extends GetMessagesEvent {
  final String chatId;
  const LoadMessages({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

final class MessagesFailed extends GetMessagesEvent {
  final String message;

  const MessagesFailed({required this.message});

  @override
  List<Object?> get props => [message];
}

final class MessagesUpdated extends GetMessagesEvent {
  final List<MessageEntity> messages;

  const MessagesUpdated({required this.messages});

  @override
  List<Object?> get props => [messages];
}

final class OnMessagesUpdated extends GetMessagesEvent {
  final List<MessageEntity> messages;
  const OnMessagesUpdated({required this.messages});

  @override
  List<Object?> get props => [messages];
}

final class OnMessagesError extends GetMessagesEvent {
  final String errorMessage;
  const OnMessagesError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
