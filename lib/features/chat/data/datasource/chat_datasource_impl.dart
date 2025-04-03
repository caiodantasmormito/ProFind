import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/chat/data/datasource/chat_datasource.dart';
import 'package:profind/features/chat/data/models/chat_model.dart';
import 'package:profind/features/chat/data/models/message_model.dart';

class ChatDatasourceImpl implements ChatDatasource {
  final FirebaseFirestore _firestore;

  ChatDatasourceImpl(this._firestore);

  @override
  Future<String> getOrCreateChat(String clientId, String providerId) async {
    final query = await _firestore
        .collection('chats')
        .where('participantsIds', arrayContains: clientId)
        .get();

    for (var doc in query.docs) {
      if (doc['participantsIds'].contains(providerId)) {
        return doc.id;
      }
    }

    final clientDoc =
        await _firestore.collection('clients').doc(clientId).get();
    final providerDoc =
        await _firestore.collection('service_providers').doc(providerId).get();

    final clientData = clientDoc.data();
    final providerData = providerDoc.data();

    final clientName = clientData?['name'] ?? 'Usuário';
    final clientSurname = clientData?['surname'] ?? '';
    final providerName = providerData?['name'] ?? 'Usuário';
    final providerSurname = providerData?['surname'] ?? '';

    final newChat = await _firestore.collection('chats').add({
      'participantsIds': [clientId, providerId],
      'participants': [
        {
          'id': clientId,
          'name': clientName,
          'surname': clientSurname,
        },
        {
          'id': providerId,
          'name': providerName,
          'surname': providerSurname,
        },
      ],
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
    try {
      return _firestore
          .collection('chats')
          .where('participantsIds', arrayContains: userId)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isEmpty) return <ChatModel>[];

        final chats = snapshot.docs.map((doc) {
          final data = doc.data();

          final participants =
              List<Map<String, dynamic>>.from(data['participants']);

          final otherUser = participants.firstWhere(
            (p) => p['id'] != userId,
            orElse: () => {},
          );

          return ChatModel(
            id: doc.id,
            participants: participants.map((p) => p['id'].toString()).toList(),
            lastMessage: data['lastMessage'] ?? '',
            lastMessageTime: data['lastMessageTime'] ?? Timestamp.now(),
            createdAt: data['createdAt'] ?? Timestamp.now(),
            otherUserName: otherUser.isNotEmpty
                ? "${otherUser['name']} ${otherUser['surname']}"
                : 'Usuário desconhecido',
          );
        }).toList();

        // Ordenação manual
        chats.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
        return chats;
      });
    } catch (e) {
      throw Exception('Chat datasource error: ${e.toString()}');
    }
  }
}
