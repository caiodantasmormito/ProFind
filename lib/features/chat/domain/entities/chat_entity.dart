import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:profind/features/chat/data/models/chat_model.dart';

class ChatEntity extends Equatable {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final Timestamp lastMessageTime;
  final Timestamp createdAt;
  final String otherUserName;

  const ChatEntity({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createdAt,
    required this.otherUserName,
  });

  @override
  List<Object?> get props => [
        id,
        participants,
        lastMessage,
        lastMessageTime,
        createdAt,
        otherUserName,
      ];

  ChatEntity copyWith({
    String? id,
    List<String>? participants,
    String? lastMessage,
    Timestamp? createdAt,
    Timestamp? lastMessageTime,
  }) {
    return ChatEntity(
      otherUserName: otherUserName,
        id: id ?? this.id,
        participants: participants ?? this.participants,
        lastMessage: lastMessage ?? this.lastMessage,
        createdAt: createdAt ?? this.createdAt,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime);
  }

  ChatModel toModel() => ChatModel(
      participants: participants,
      otherUserName: otherUserName,
      id: id,
      lastMessage: lastMessage,
      createdAt: createdAt,
      lastMessageTime: lastMessageTime);
}
