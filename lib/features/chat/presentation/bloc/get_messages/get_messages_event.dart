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

final class ResetMessages extends GetMessagesEvent {
  @override
  
  List<Object?> get props => [];
}