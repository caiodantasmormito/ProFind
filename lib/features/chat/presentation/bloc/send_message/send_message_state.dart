part of 'send_message_bloc.dart';

sealed class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object?> get props => [];
}

class SendMessageInitial extends SendMessageState {}

final class SendMessageLoading extends SendMessageState {}

final class SendMessageError extends SendMessageState {
  final String? message;

  const SendMessageError({required this.message});
}

final class SendMessageSuccess extends SendMessageState {}
