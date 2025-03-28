

import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/messages/domain/entities/messages_entity.dart';

abstract class MessagesRepository {
  Future<(Failure?, NoParams?)> sendMessage(
      {required MessagesEntity messagesEntity});
  Future<(Failure?, List<MessagesEntity>?)> getMessages(String userId);
  }
