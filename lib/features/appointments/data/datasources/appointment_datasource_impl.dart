import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/appointments/data/datasources/appointment_datasource.dart';
import 'package:profind/features/appointments/data/exceptions/exceptions.dart';
import 'package:profind/features/appointments/data/models/appointment_model.dart';

final class AppointmentDataSourceImpl implements AppointmentDataSource {
  final FirebaseFirestore _firestore;

  AppointmentDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<AppointmentModel>> getProviderAppointments(
      {required String providerId}) async {
    try {
      final querySnapshot = await _firestore
          .collection('appointments')
          .where('providerId', isEqualTo: providerId)
          .get();

      return querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data(), id: doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw GetProviderAppointmentException(
          message: 'Erro ao buscar agendamentos: ${e.message}');
    }
  }

  @override
  Future<AppointmentModel> createAppointment(
      {required AppointmentModel appointment}) async {
    try {
      final isAvailable = await isTimeSlotAvailable(
        providerId: appointment.providerId,
        dateTime: appointment.dateTime,
      );

      if (!isAvailable) {
        throw Exception('Horário já está ocupado');
      }

      final docRef = await _firestore.collection('appointments').add({
        ...appointment.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      final docSnapshot = await docRef.get();
      return AppointmentModel.fromJson(
        docSnapshot.data()!,
        id: docSnapshot.id,
      );
    } on FirebaseException catch (e) {
      throw CreateAppointmentException(
          message: 'Erro ao criar agendamento: ${e.message}');
    }
  }

  @override
  Future<bool> isTimeSlotAvailable(
      {required String providerId, required DateTime dateTime}) async {
    try {
      final startTime = dateTime;
      final endTime = dateTime.add(const Duration(hours: 1));

      final querySnapshot = await _firestore
          .collection('appointments')
          .where('providerId', isEqualTo: providerId)
          .where('dateTime',
              isGreaterThanOrEqualTo: startTime.toIso8601String())
          .where('dateTime', isLessThan: endTime.toIso8601String())
          .where('status', whereIn: ['available', 'booked']).get();

      return querySnapshot.docs.isEmpty;
    } on FirebaseException catch (e) {
      throw AppointmentException(
          message: 'Erro ao verificar disponibilidade: ${e.message}');
    }
  }

  @override
  Future<void> updateAppointmentStatus(
      {required String appointmentId, required String status}) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw UpdateAppointmentException(
          message: 'Erro ao atualizar status: ${e.message}');
    }
  }

  @override
  Stream<List<AppointmentModel>> watchProviderAppointments(
      {required String providerId}) {
    return _firestore
        .collection('appointments')
        .where('providerId', isEqualTo: providerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppointmentModel.fromJson(doc.data(), id: doc.id))
            .toList());
  }
}
