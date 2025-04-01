import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String text;
  final Timestamp timestamp;
  //final bool read;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    //required this.read,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        text,
        timestamp,
      ]; //read];

  MessageEntity copyWith({
    String? id,
    String? senderId,
    String? text,
    Timestamp? timestamp,
    //bool? read,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      //read: read ?? this.read,
    );
  }
}
