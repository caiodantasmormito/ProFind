import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/appointments/domain/repositories/appointment_repository.dart';

class UpdateAppointmentStatusUsecase implements UseCase<void, (String, String)> {
  final AppointmentRepository _repository;

  UpdateAppointmentStatusUsecase(this._repository);

  @override
  Future<(Failure?, void)> call((String, String) params) async {
    final (appointmentId, status) = params;
    return await _repository.updateAppointmentStatus(
        appointmentId: appointmentId, status: status);
  }
}
