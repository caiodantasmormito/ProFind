class AppointmentException implements Exception {
  const AppointmentException({required this.message});
  final String message;
}
class CreateAppointmentException implements Exception {
  const CreateAppointmentException({required this.message});
  final String message;
}
class GetProviderAppointmentException implements Exception {
  const GetProviderAppointmentException({required this.message});
  final String message;
}
class UpdateAppointmentException implements Exception {
  const UpdateAppointmentException({required this.message});
  final String message;
}


