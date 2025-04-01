import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/chat/domain/entities/message_entity.dart';

abstract class MessagesRepository {
  Future<(Failure?, String?)> createChat(String clientId, String providerId);
  Future<(Failure?, void)> sendMessage(
      {required String chatId, required String senderId, required String text});
  Stream<(Failure?, List<MessageEntity>?)> getChatMessages(String chatId);
  Future<(Failure?, List<MessageEntity>?)> getUserChats(String userId);
}
