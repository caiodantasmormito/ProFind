
part of 'get_chats_bloc.dart';

abstract class GetChatEvent extends Equatable {
  const GetChatEvent();
}

class InitializeChat extends GetChatEvent {
  final String clientId;
  final String providerId;

  const InitializeChat({
    required this.clientId,
    required this.providerId,
  });

  @override
  List<Object> get props => [clientId, providerId];
}