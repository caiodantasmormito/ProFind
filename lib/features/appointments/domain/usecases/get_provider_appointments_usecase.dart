import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/appointments/domain/entities/appointment_entity.dart';
import 'package:profind/features/appointments/domain/repositories/appointment_repository.dart';

class GetProviderAppointmentsUsecase
    implements UseCase<List<AppointmentEntity>, String> {
  final AppointmentRepository _repository;

  GetProviderAppointmentsUsecase(this._repository);

  @override
  Future<(Failure?, List<AppointmentEntity>?)> call(String providerId) async {
    return await _repository.getProviderAppointments(providerId: providerId);
  }
}
