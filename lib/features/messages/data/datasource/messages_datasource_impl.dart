import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/features/messages/data/datasource/messages_datasource.dart';
import 'package:profind/features/messages/data/exceptions/exceptions.dart';
import 'package:profind/features/messages/data/models/messages_model.dart';

class MessagesDatasourceImpl implements MessagesDatasource {
  @override
  Future<List<MessagesModel>> getMessages(String userId) async {
    try {
      final collection = FirebaseFirestore.instance.collection("messages");

      final querySnapshot =
          await collection.where('userId', isEqualTo: userId).get();

      final contacts = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return MessagesModel.fromMap(data);
      }).toList();

      return contacts;
    } catch (e) {
      throw MessagesExeception(message: "Falha ao buscar mensagens: $e");
    }
  }

  @override
  Future<void> sendMessage({required MessagesModel messagesModel}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final collection = FirebaseFirestore.instance.collection("messages");
      final newDoc = collection.doc();

      await newDoc.set({
        "id": newDoc.id,
        "message": messagesModel.message,
        "userId": user!.uid,
      });

      return;
    } catch (e) {
      throw MessagesExeception(message: "Falha ao enviar mensagem: $e");
    }
  }
}
