import 'package:equatable/equatable.dart';
import 'package:profind/features/messages/data/models/messages_model.dart';

class MessagesEntity extends Equatable {
  final String id;
  final String message;

  const MessagesEntity({
    required this.id,
    required this.message,
  });

  @override
  List<Object?> get props => [
        id,
        message,
      ];

  MessagesEntity copyWith({
    String? id,
    String? message,
  }) {
    return MessagesEntity(
      id: id ?? this.id,
      message: message ?? this.message,
    );
  }

  MessagesModel toModel() => MessagesModel(
        message: message,
        id: id,
      );
}
