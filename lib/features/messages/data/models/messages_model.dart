import 'dart:convert';

import 'package:profind/features/messages/domain/entities/messages_entity.dart';


class MessagesModel extends MessagesEntity {
  const MessagesModel({
    required super.id,
    required super.message,
    
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      
    };
  }

  factory MessagesModel.fromMap(Map<String, dynamic> map) {
    return MessagesModel(
      id: map['id'],
      message: map['message'],
      
    );
  }

  String toJson() => jsonEncode(toMap());

  factory MessagesModel.fromJson(String source) =>
      MessagesModel.fromMap(json.decode(source));
}
