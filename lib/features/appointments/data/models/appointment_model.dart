import 'package:profind/features/appointments/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    super.clientId,
    super.clientName,
    required super.dateTime,
    required super.price,
    required super.service,
    required super.status,
    required super.createdAt,
    required super.providerId,
    super.id,
  });

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      providerId: entity.providerId,
      clientId: entity.clientId,
      clientName: entity.clientName,
      dateTime: entity.dateTime,
      service: entity.service,
      price: entity.price,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'providerId': providerId,
      'clientId': clientId,
      'clientName': clientName,
      'dateTime': dateTime.toIso8601String(),
      'service': service,
      'price': price,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return AppointmentModel(
      id: id,
      providerId: json['providerId'],
      clientId: json['clientId'],
      clientName: json['clientName'],
      dateTime: DateTime.parse(json['dateTime']),
      service: json['service'],
      price: json['price'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
