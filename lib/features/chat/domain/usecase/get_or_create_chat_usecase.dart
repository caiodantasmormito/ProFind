import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/chat/domain/repositories/messages_repository.dart';

class GetOrCreateChatUsecase implements UseCase<String, CreateChatParams> {
  final ChatRepository _repository;

  GetOrCreateChatUsecase({required ChatRepository repository})
      : _repository = repository;

  @override
  Future<(Failure?, String?)> call(CreateChatParams params) async {
    return await _repository.getOrCreateChat(params.clientId, params.providerId);
  }
}

class CreateChatParams {
  final String clientId;
  final String providerId;

  CreateChatParams({
    required this.clientId,
    required this.providerId,
  });
}
