import 'package:profind/features/chat/data/models/chat_model.dart';
import 'package:profind/features/chat/data/models/message_model.dart';

abstract class MessagesDatasource {
  Future<String> getOrCreateChat(String clientId, String providerId);
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  });
  Stream<List<MessageModel>> getMessages(String chatId);
  Stream<List<ChatModel>> getUserChats(String userId);
}
