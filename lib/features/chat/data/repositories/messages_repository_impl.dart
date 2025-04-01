import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/chat/data/datasource/messages_datasource.dart';
import 'package:profind/features/chat/domain/entities/chat_entity.dart';
import 'package:profind/features/chat/domain/entities/message_entity.dart';
import 'package:profind/features/chat/domain/failures/failures.dart';
import 'package:profind/features/chat/domain/repositories/messages_repository.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesDatasource _datasource;

  MessagesRepositoryImpl({required MessagesDatasource datasource})
      : _datasource = datasource;

  @override
  Future<(Failure?, String?)> createChat(
      String clientId, String providerId) async {
    try {
      final chatId = await _datasource.createChat(clientId, providerId);
      return (null, chatId);
    } catch (e) {
      return (
        MessagesFailure(
          message: 'Failed to create chat',
        ),
        null,
      );
    }
  }

  @override
  Future<(Failure?, void)> sendMessage(
      {required String chatId,
      required String senderId,
      required String text}) async {
    try {
      await _datasource.sendMessage(
          chatId: chatId, senderId: senderId, text: text);
      return (null, null);
    } catch (e) {
      return (
        MessagesFailure(
          message: 'Failed to send message',
        ),
        null,
      );
    }
  }

  @override
  Stream<(Failure?, List<MessageEntity>?)> getChatMessages(String chatId) {
    return _datasource.getChatMessages(chatId).asyncExpand((models) {
      try {
        final entities = models.map((model) => model.toEntity()).toList();
        return Stream.value((null, entities));
      } catch (e) {
        return Stream.value((
          MessagesFailure(message: 'Conversion error: ${e.toString()}'),
          null
        ));
      }
    }).handleError((error) {
      return (
        MessagesFailure(message: 'Repository error: ${error.toString()}'),
        null
      );
    });
  }

    @override
  Future<(Failure?, List<MessageEntity>?)> getUserChats(String userId) async {
    try {
      final models = await _datasource.getUserChats(userId);
      final entities = models.map((model) => model.toEntity()).toList();
      return (null, entities);
    } catch (e) {
      return (
        MessagesFailure(
          message: 'Erro ao buscar conversas: ${e.toString()}',
          
        ),
        <MessageEntity>[],
      );
    }
  }
}
