

import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/messages/data/datasource/messages_datasource.dart';
import 'package:profind/features/messages/data/exceptions/exceptions.dart';
import 'package:profind/features/messages/domain/entities/messages_entity.dart';
import 'package:profind/features/messages/domain/failures/failures.dart';
import 'package:profind/features/messages/domain/repositories/messages_repository.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesDatasource _messagesDataSource;

  MessagesRepositoryImpl({required MessagesDatasource messagesDataSource})
      : _messagesDataSource = messagesDataSource;

  @override
  Future<(Failure?, NoParams?)> sendMessage(
      {required MessagesEntity messagesEntity}) async {
    try {
      await _messagesDataSource.sendMessage(
          messagesModel: messagesEntity.toModel());
      return (null, null);
    } on MessagesExeception catch (error) {
      return (
        MessagesFailure(message: error.message),
        null,
      );
    }
  }

  @override
  Future<(Failure?, List<MessagesEntity>?)> getMessages(String userId) async {
    try {
      final result = await _messagesDataSource.getMessages(userId);
      return (null, result);
    } on MessagesExeception catch (error) {
      return (
        MessagesFailure(message: error.message),
        null,
      );
    }
  }
 
}
