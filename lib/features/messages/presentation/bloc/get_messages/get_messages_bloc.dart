import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profind/features/messages/domain/entities/messages_entity.dart';
import 'package:profind/features/messages/domain/usecase/get_messages_usecase.dart';

part 'get_messages_event.dart';
part 'get_messages_state.dart';

class GetMessagesBloc extends Bloc<GetMessagesEvent, GetMessagesState> {
  final GetMessagesUsecase useCase;
  GetMessagesBloc({required this.useCase}) : super(GetMessagesInitial()) {
    on<GetMessages>((event, emit) async {
      emit(GetMessagesLoading());
      final (failure, result) = await useCase(event.userId);

      if (failure == null) {
        emit(GetMessagesSuccess(messages: result!));
      } else {
        emit(GetMessagesError(message: failure.message));
      }
    });
  }
}
