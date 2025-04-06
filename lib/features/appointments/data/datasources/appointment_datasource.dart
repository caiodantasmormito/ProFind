import 'package:profind/features/appointments/data/models/appointment_model.dart';

abstract interface class AppointmentDataSource {
  Future<List<AppointmentModel>> getProviderAppointments(
      {required String providerId});
  Future<AppointmentModel> createAppointment(
      {required AppointmentModel appointment});
  Future<bool> isTimeSlotAvailable(
      {required String providerId, required DateTime dateTime});
  Future<void> updateAppointmentStatus(
      {required String appointmentId, required String status});
  Stream<List<AppointmentModel>> watchProviderAppointments(
      {required String providerId});
}
