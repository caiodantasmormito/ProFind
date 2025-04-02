import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/chat/data/datasource/messages_datasource.dart';
import 'package:profind/features/chat/data/models/chat_model.dart';
import 'package:profind/features/chat/data/models/message_model.dart';

class MessagesDatasourceImpl implements MessagesDatasource {
  final FirebaseFirestore _firestore;

  MessagesDatasourceImpl(this._firestore);

  @override
  Future<String> getOrCreateChat(String clientId, String providerId) async {
    final query = await _firestore
        .collection('chats')
        .where('participants', arrayContains: clientId)
        .get();

    for (var doc in query.docs) {
      if (doc['participants'].contains(providerId)) {
        return doc.id;
      }
    }

    final newChat = await _firestore.collection('chats').add({
      'participants': [clientId, providerId],
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return newChat.id;
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final chatRef = _firestore.collection('chats').doc(chatId);
    final messagesRef = _firestore.collection('messages/$chatId/messages');

    await _firestore.runTransaction((transaction) async {
      transaction.set(messagesRef.doc(), {
        'senderId': senderId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });

      transaction.update(chatRef, {
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('messages/$chatId/messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc))
            .toList());
  }

  @override
  Stream<List<ChatModel>> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatModel.fromFirestore(doc)).toList());
  }
}
