import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/appointments/domain/entities/appointment_entity.dart';
import 'package:profind/features/appointments/domain/repositories/appointment_repository.dart';

class WatchProviderAppointmentsUsecase
    implements StreamUseCase<List<AppointmentEntity>, String> {
  final AppointmentRepository _repository;

  WatchProviderAppointmentsUsecase(this._repository);

  @override
  Stream<(Failure?, List<AppointmentEntity>)> call(String providerId) {
    return _repository
        .watchProviderAppointments(providerId: providerId)
        .map((tuple) {
      final (failure, appointments) = tuple;

      final appointmentsList = appointments ?? [];

      return (failure, appointmentsList);
    });
  }
}
