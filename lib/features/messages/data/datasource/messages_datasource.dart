

import 'package:profind/features/messages/data/models/messages_model.dart';

abstract interface class MessagesDatasource {
  Future<void> sendMessage({required MessagesModel messagesModel});
  Future<List<MessagesModel>> getMessages(String userId);

}
