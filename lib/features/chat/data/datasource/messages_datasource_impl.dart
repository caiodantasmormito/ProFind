import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/chat/data/datasource/messages_datasource.dart';
import 'package:profind/features/chat/data/models/message_model.dart';

class MessagesDatasourceImpl implements MessagesDatasource {
  final FirebaseFirestore _firestore;

  MessagesDatasourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<String> createChat(String clientId, String providerId) async {
    final doc = await _firestore.collection('chats').add({
      'participants': [clientId, providerId],
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  @override
  Future<void> sendMessage(
      {required String chatId,
      required String senderId,
      required String text}) async {
    await _firestore.runTransaction((transaction) async {
      final messagesRef = _firestore.collection('chats/$chatId/messages');
      transaction.set(messagesRef.doc(), {
        'senderId': senderId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });

      final chatRef = _firestore.collection('chats').doc(chatId);
      transaction.update(chatRef, {
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: chatId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<List<MessageModel>> getUserChats(String userId) async {
    final snapshot = await _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    return snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList();
  }
}
