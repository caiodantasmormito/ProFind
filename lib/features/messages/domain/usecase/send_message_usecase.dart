import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/messages/domain/entities/messages_entity.dart';
import 'package:profind/features/messages/domain/repositories/messages_repository.dart';

class SendMessageUsecase implements UseCase<NoParams, MessagesEntity> {
  final MessagesRepository _repository;

  const SendMessageUsecase({
    required MessagesRepository repository,
  }) : _repository = repository;

  @override
  Future<(Failure?, NoParams?)> call(MessagesEntity params) async =>
      await _repository.sendMessage(messagesEntity: params);
}
