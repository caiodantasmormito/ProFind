import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel(
      {required super.id,
      required super.participants,
      required super.lastMessage,
      required super.lastMessageTime,
      required super.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'createdAt': createdAt,
    };
  }
  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      participants: participants,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      createdAt: createdAt,
    );
  }

   factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: data['lastMessageTime'] ?? Timestamp.now(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromFirestore(json.decode(source));
}
