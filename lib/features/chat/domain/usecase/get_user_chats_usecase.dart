import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/chat/domain/entities/chat_entity.dart';
import 'package:profind/features/chat/domain/failures/failures.dart';
import 'package:profind/features/chat/domain/repositories/messages_repository.dart';

class GetUserChatsUsecase implements StreamUseCase<List<ChatEntity>, String> {
  final ChatRepository _repository;

  GetUserChatsUsecase({required ChatRepository repository})
      : _repository = repository;

  @override
  Stream<(Failure?, List<ChatEntity>)> call(String userId) async* {
    try {
      await for (final result in _repository.getUserChats(userId)) {
        final (failure, chats) = result;

        if (failure != null) {
          yield (failure, const []);
          continue;
        }

        yield (null, chats ?? []);
      }
    } catch (e) {
      yield (
        MessagesFailure(message: 'Unexpected error: ${e.toString()}'),
        const [],
      );
    }
  }
}
