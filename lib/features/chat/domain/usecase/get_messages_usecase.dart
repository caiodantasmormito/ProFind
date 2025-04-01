import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/chat/domain/entities/message_entity.dart';
import 'package:profind/features/chat/domain/repositories/messages_repository.dart';

class GetMessagesUsecase implements StreamUseCase<List<MessageEntity>, String> {
  final MessagesRepository _repository;

  GetMessagesUsecase({required MessagesRepository repository})
      : _repository = repository;

  @override
  Stream<(Failure?, List<MessageEntity>)> call(String chatId) {
    return _repository.getChatMessages(chatId).map((tuple) {
      final (failure, messages) = tuple;

      final messagesList = messages ?? [];

      return (failure, messagesList);
    });
  }
}
