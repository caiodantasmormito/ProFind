import 'package:profind/features/chat/data/models/chat_model.dart';
import 'package:profind/features/chat/data/models/message_model.dart';

abstract interface class MessagesDatasource {
  Future<String> createChat(String clientId, String providerId);
  Future<void> sendMessage(
      {required String chatId, required String senderId, required String text});
  Stream<List<MessageModel>> getChatMessages(String chatId);
  Future<List<MessageModel>> getUserChats(String userId);
}
