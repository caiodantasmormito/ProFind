import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/appointments/domain/entities/appointment_entity.dart';

abstract interface class AppointmentRepository {
  Future<(Failure?, List<AppointmentEntity>?)> getProviderAppointments(
      {required String providerId});
  Future<(Failure?, List<AppointmentEntity>?)> createAppointment(
      {required AppointmentEntity appointment});
  Future<(Failure?, bool?)> isTimeSlotAvailable(
      {required String providerId, required DateTime dateTime});
  Future<(Failure?, void)> updateAppointmentStatus(
      {required String appointmentId, required String status});
  Stream<(Failure?, List<AppointmentEntity>?)> watchProviderAppointments(
      {required String providerId});
}
