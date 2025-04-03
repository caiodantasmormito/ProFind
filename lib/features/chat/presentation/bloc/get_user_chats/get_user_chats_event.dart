part of 'get_user_chats_bloc.dart';

sealed class GetUserChatsEvent extends Equatable {
  const GetUserChatsEvent();
}

final class LoadChats extends GetUserChatsEvent {
  final String userId;
  const LoadChats({required this.userId});

  @override
  List<Object?> get props => [userId];
}



