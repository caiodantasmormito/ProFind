import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/chat/domain/repositories/messages_repository.dart';

class SendMessageUsecase implements VoidUseCase<SendMessageParams> {
  final ChatRepository _repository;

  SendMessageUsecase({required ChatRepository repository})
      : _repository = repository;

  @override
  Future<(Failure?, void)> call(SendMessageParams params) async {
    return await _repository.sendMessage(
      chatId: params.chatId,
      senderId: params.senderId,
      text: params.text,
    );
  }
}

class SendMessageParams {
  final String chatId;
  final String text;
  final String senderId;

  SendMessageParams({
    required this.chatId,
    required this.text,
    required this.senderId,
  });
}
