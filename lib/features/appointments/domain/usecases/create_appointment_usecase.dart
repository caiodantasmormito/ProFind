import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/appointments/domain/entities/appointment_entity.dart';
import 'package:profind/features/appointments/domain/repositories/appointment_repository.dart';

class CreateAppointmentUseCase implements UseCase<List<AppointmentEntity>, AppointmentEntity> {
  final AppointmentRepository _repository;

  CreateAppointmentUseCase(this._repository);

  @override
  Future<(Failure?, List<AppointmentEntity>?)> call(AppointmentEntity params) async {
    return await _repository.createAppointment(appointment: params);
  }
}


