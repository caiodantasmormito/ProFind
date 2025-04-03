part of 'get_or_create_chat_bloc.dart';

abstract class GetOrCreateChatEvent extends Equatable {
  const GetOrCreateChatEvent();
}

class InitializeChat extends GetOrCreateChatEvent {
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

class NewSendMessage extends GetOrCreateChatEvent {
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
