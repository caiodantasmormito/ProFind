import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.text,
    required super.timestamp,
    //required super.read,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      //'read': read,
    };
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      senderId: senderId,
      text: text,
      timestamp: timestamp,
      //read: read,
    );
  }

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
        id: doc.id,
        senderId: data['senderId'] ?? '',
        text: data['text'] ?? '',
        timestamp: data['timestamp'] ?? Timestamp.now(),
        //read: data['read'] ?? ''
        );
  }

  String toJson() => jsonEncode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromFirestore(json.decode(source));
}
