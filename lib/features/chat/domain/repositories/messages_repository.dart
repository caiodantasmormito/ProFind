import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/chat/domain/entities/chat_entity.dart';
import 'package:profind/features/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<(Failure?, String?)> getOrCreateChat(String clientId, String providerId);
  Future<(Failure?, void)> sendMessage(
      {required String chatId, required String senderId, required String text});
  Stream<(Failure?, List<MessageEntity>?)> getChatMessages(String chatId);
   Stream<(Failure?, List<ChatEntity>?)> getUserChats(String userId);
}

 
  
