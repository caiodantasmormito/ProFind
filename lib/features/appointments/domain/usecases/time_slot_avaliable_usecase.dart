import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/core/domain/usecase/usecase.dart';
import 'package:profind/features/appointments/domain/repositories/appointment_repository.dart';

class TimeSlotAvaliableUsecase implements UseCase<bool, (String, DateTime)> {
  final AppointmentRepository _repository;

  TimeSlotAvaliableUsecase(this._repository);

  @override
  Future<(Failure?, bool?)> call((String, DateTime) params) async {
    final (providerId, dateTime) = params;
    return await _repository.isTimeSlotAvailable(
        providerId: providerId, dateTime: dateTime);
  }
}
