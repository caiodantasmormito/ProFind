import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';

import 'package:profind/features/chat/domain/entities/message_entity.dart';
import 'package:profind/features/chat/domain/repositories/messages_repository.dart';

class GetChatsUsecase implements UseCase<List<MessageEntity>, String> {
  final MessagesRepository _repository;

  GetChatsUsecase({required MessagesRepository repository})
      : _repository = repository;

  @override
  Future<(Failure?, List<MessageEntity>?)> call(String userId) async {
    return await _repository.getUserChats(userId);
  }
}
