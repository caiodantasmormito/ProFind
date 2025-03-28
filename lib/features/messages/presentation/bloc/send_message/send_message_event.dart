part of 'send_message_bloc.dart';

sealed class SendMessageEvent extends Equatable {
  const SendMessageEvent();
}

final class SendMessage extends SendMessageEvent {
  const SendMessage(this.params);
  final MessagesEntity params;
  @override
  List<Object> get props => [params];
}
