import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/messages/domain/entities/messages_entity.dart';
import 'package:profind/features/messages/domain/repositories/messages_repository.dart';

class GetMessagesUsecase implements UseCase<List<MessagesEntity>, String> {
  final MessagesRepository _repository;
  GetMessagesUsecase({required MessagesRepository repository})
      : _repository = repository;

  @override
  Future<(Failure?, List<MessagesEntity>?)> call(String userId) =>
      _repository.getMessages(userId);
}
