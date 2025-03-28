part of 'get_messages_bloc.dart';

sealed class GetMessagesEvent extends Equatable {
  const GetMessagesEvent();
}

final class GetMessages extends GetMessagesEvent {
  final String userId;
  const GetMessages({required this.userId});

  @override
  List<Object?> get props => [userId];
}

