part of 'get_messages_bloc.dart';

sealed class GetMessagesState extends Equatable {
  const GetMessagesState();
  
  @override
  List<Object?> get props => [];
}

class GetMessagesInitial extends GetMessagesState {}

class GetMessagesLoading extends GetMessagesState {}

class GetMessagesError extends GetMessagesState {
  final String message;
  
  const GetMessagesError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class GetMessagesSuccess extends GetMessagesState {
  final List<MessageEntity> messages;
  
  const GetMessagesSuccess({required this.messages});
  
  @override
  List<Object?> get props => [messages];
}

class GetMessagesStream extends GetMessagesState {
  final Stream<List<MessageEntity>> messagesStream;
  
  const GetMessagesStream({required this.messagesStream});
  
  @override
  List<Object?> get props => [messagesStream];
}