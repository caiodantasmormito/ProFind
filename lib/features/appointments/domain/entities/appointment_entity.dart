import 'package:equatable/equatable.dart';
import 'package:profind/features/appointments/data/models/appointment_model.dart';

class AppointmentEntity extends Equatable {
  final String? id;
  final String providerId;
  final String? clientId;
  final String? clientName;
  final DateTime dateTime;

  final String service;
  final double price;
  final String status;
  final DateTime createdAt;

  const AppointmentEntity({
    this.id,
    required this.providerId,
    this.clientId,
    this.clientName,
    required this.dateTime,
    required this.service,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        providerId,
        clientId,
        clientName,
        dateTime,
        service,
        price,
        status,
        createdAt,
      ];

       AppointmentEntity copyWith({
    String? id,
    
    String? providerId,
    String? clientId,
    String? clientName,
    DateTime? dateTime,
    String? service,
    double? price,
    String? status,
    DateTime? createdAt,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      dateTime: dateTime ?? this.dateTime,
      service: service ?? this.service,
      price: price ?? this.price,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
     
    );
  }

  AppointmentModel toModel() => AppointmentModel(
        providerId: providerId,
        clientId: clientId,
        clientName: clientName,
        dateTime: dateTime,
        service: service,
        price: price,
        status: status,
        createdAt: createdAt,
      );
}

