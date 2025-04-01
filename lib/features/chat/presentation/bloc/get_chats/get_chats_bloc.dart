import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profind/features/chat/domain/usecase/create_chat_usecase.dart';
import 'package:profind/features/chat/domain/usecase/get_chats_usecase.dart';

part 'get_chats_event.dart';
part 'get_chats_state.dart';

class ChatBloc extends Bloc<GetChatEvent, GetChatState> {
  final CreateChatUsecase createChatUsecase;
  final GetChatsUsecase getChatUsecase;

  ChatBloc({
    required this.createChatUsecase,
    required this.getChatUsecase,
  }) : super(GetChatInitial()) {
    on<InitializeChat>(_onInitializeChat);
  }

  Future<void> _onInitializeChat(
    InitializeChat event,
    Emitter<GetChatState> emit,
  ) async {
    emit(GetChatLoading());

    final (failure, chats) = await getChatUsecase(event.clientId);

    if (failure != null) {
      emit(GetChatError(message: failure.toString()));
    } else if (chats != null && chats.isNotEmpty) {
      final chatIds = chats.map((chat) => chat.id).toList();
      emit(GetChatSuccess(chatId: chatIds));
    } else {
      final (createFailure, newChatId) = await createChatUsecase(
        CreateChatParams(
          clientId: event.clientId,
          providerId: event.providerId,
        ),
      );

      if (createFailure != null) {
        emit(GetChatError(message: createFailure.toString()));
      } else {
        emit(GetChatSuccess(chatId: [newChatId!]));
      }
    }
  }
}
