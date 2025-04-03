part of 'get_user_chats_bloc.dart';

sealed class GetUserChatsState extends Equatable {
  const GetUserChatsState();
  
  @override
  List<Object?> get props => [];
}

class GetUserChatsInitial extends GetUserChatsState {}

class GetUserChatsLoading extends GetUserChatsState {}

class GetUserChatsError extends GetUserChatsState {
  final String message;
  
  const GetUserChatsError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class GetUserChatsSuccess extends GetUserChatsState {
  final List<ChatEntity> chats;
  
  const GetUserChatsSuccess({required this.chats});
  
  @override
  List<Object?> get props => [chats];
}
