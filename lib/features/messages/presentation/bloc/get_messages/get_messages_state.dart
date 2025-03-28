part of 'get_messages_bloc.dart';

sealed class GetMessagesState extends Equatable {
  const GetMessagesState();

  @override
  List<Object?> get props => [];
}

class GetMessagesInitial extends GetMessagesState {}

final class GetMessagesLoading extends GetMessagesState {}

final class GetMessagesError extends GetMessagesState {
  final String? message;

  const GetMessagesError({required this.message});
}

final class GetMessagesSuccess extends GetMessagesState {
  const GetMessagesSuccess({required this.messages});
  final List<MessagesEntity> messages;
  @override
  List<Object> get props => [messages];
}
