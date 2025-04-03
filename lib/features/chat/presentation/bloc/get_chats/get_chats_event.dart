part of 'get_chats_bloc.dart';

abstract class GetChatEvent extends Equatable {
  const GetChatEvent();
}

class InitializeChat extends GetChatEvent {
  final String clientId;
  final String providerId;
  final String providerName;

  const InitializeChat({
    required this.clientId,
    required this.providerId,
    required this.providerName,
  });

  @override
  List<Object> get props => [clientId, providerId];
}

class NewSendMessage extends GetChatEvent {
  final String chatId;
  final String senderId;
  final String text;

  const NewSendMessage({
    required this.chatId,
    required this.senderId,
    required this.text,
  });

  @override
  List<Object?> get props => [chatId, senderId, text];
}
