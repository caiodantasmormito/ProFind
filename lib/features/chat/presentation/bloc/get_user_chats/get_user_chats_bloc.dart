import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:profind/features/chat/domain/entities/chat_entity.dart';
import 'package:profind/features/chat/domain/usecase/get_user_chats_usecase.dart';

part 'get_user_chats_event.dart';
part 'get_user_chats_state.dart';

class GetUserChatsBloc extends Bloc<GetUserChatsEvent, GetUserChatsState> {
  final GetUserChatsUsecase _getUserChatsUsecase;

  GetUserChatsBloc({required GetUserChatsUsecase getUserChatsUsecase})
      : _getUserChatsUsecase = getUserChatsUsecase,
        super(GetUserChatsInitial()) {
    on<LoadChats>(_onLoadUserChats);
  }

  Future<void> _onLoadUserChats(
    LoadChats event,
    Emitter<GetUserChatsState> emit,
  ) async {
    if (isClosed) return;

    emit(GetUserChatsLoading());

    try {
      await for (final (failure, chats) in _getUserChatsUsecase(event.userId)) {
        if (isClosed) return;

        if (failure != null) {
          emit(GetUserChatsError(message: failure.message.toString()));
        } else {
          emit(GetUserChatsSuccess(chats: chats));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(GetUserChatsError(
            message: 'Failed to load messages: ${e.toString()}'));
      }
    }
  }
}
