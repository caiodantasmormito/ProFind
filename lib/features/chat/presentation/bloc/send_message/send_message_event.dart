part of 'send_message_bloc.dart';

sealed class SendMessageEvent extends Equatable {
  const SendMessageEvent();
}

final class SendMessage extends SendMessageEvent {
  final String chatId;
  final String text;
  final String senderId;

  const SendMessage({
    required this.chatId,
    required this.text,
    required this.senderId,
  });

  @override
  List<Object> get props => [chatId, text, senderId];
}