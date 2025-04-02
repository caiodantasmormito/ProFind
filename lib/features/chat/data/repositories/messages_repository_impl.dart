import 'dart:async';

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
  Future<(Failure?, String?)> getOrCreateChat(
    String clientId,
    String providerId,
  ) async {
    try {
      final chatId = await _datasource.getOrCreateChat(clientId, providerId);
      return (null, chatId);
    } on Exception catch (e) {
      return (
        MessagesFailure(message: e.toString()),
        null,
      );
    }
  }

  @override
  Future<(Failure?, void)> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    try {
      await _datasource.sendMessage(
        chatId: chatId,
        senderId: senderId,
        text: text,
      );
      return (null, null);
    } on Exception catch (e) {
      return (
        MessagesFailure(
          message: e.toString(),
        ),
        null,
      );
    }
  }

  @override
  Stream<(Failure?, List<MessageEntity>?)> getChatMessages(String chatId) {
    return _datasource.getMessages(chatId).transform(
          StreamTransformer.fromHandlers(
            handleData: (models, sink) {
              try {
                final entities =
                    models.map((model) => model.toEntity()).toList();
                sink.add((null, entities));
              } catch (e) {
                sink.addError((
                  MessagesFailure(
                    message: e.toString(),
                  ),
                  null,
                ));
              }
            },
            handleError: (error, stackTrace, sink) {
              sink.add((
                MessagesFailure(
                  message: error.toString(),
                ),
                null,
              ));
            },
          ),
        );
  }

  @override
  Stream<(Failure?, List<ChatEntity>?)> getUserChats(String userId) {
    return _datasource.getUserChats(userId).asyncMap((models) {
      try {
        final entities = models
            .map((model) => ChatEntity(
                  id: model.id,
                  participants: model.participants,
                  lastMessage: model.lastMessage,
                  lastMessageTime: model.lastMessageTime,
                  createdAt: model.createdAt,
                ))
            .toList();
        return (null, entities);
      } catch (e) {
        return (
          MessagesFailure(message: 'Conversion error: ${e.toString()}'),
          null,
        );
      }
    }).handleError((error) {
      return (
        MessagesFailure(message: 'Stream error: ${error.toString()}'),
        null,
      );
    });
  }
}
