import 'package:profind/core/domain/failure/failure.dart';
import 'package:profind/features/appointments/data/datasources/appointment_datasource.dart';
import 'package:profind/features/appointments/data/exceptions/exceptions.dart';
import 'package:profind/features/appointments/domain/entities/appointment_entity.dart';
import 'package:profind/features/appointments/domain/failures/failures.dart';
import 'package:profind/features/appointments/domain/repositories/appointment_repository.dart';

final class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentDataSource _dataSource;

  AppointmentRepositoryImpl(this._dataSource);

  @override
  Future<(Failure?, List<AppointmentEntity>?)> getProviderAppointments(
      {required String providerId}) async {
    try {
      final result =
          await _dataSource.getProviderAppointments(providerId: providerId);
      return (null, result);
    } on GetProviderAppointmentException catch (error) {
      return (
        AppointmentFailure(message: error.message),
        null,
      );
    }
  }

  @override
  Future<(Failure?, List<AppointmentEntity>?)> createAppointment(
      {required AppointmentEntity appointment}) async {
    try {
      final isAvailable = await _dataSource.isTimeSlotAvailable(
        providerId: appointment.providerId,
        dateTime: appointment.dateTime,
      );

      if (!isAvailable) {
        return (AppointmentFailure(message: 'Horário já está ocupado'), null);
      }

      final result = await _dataSource.createAppointment(
          appointment: appointment.toModel());
      return (null, [result]);
    } on CreateAppointmentException catch (error) {
      return (AppointmentFailure(message: error.message), null);
    } catch (e) {
      return (AppointmentFailure(message: e.toString()), null);
    }
  }

  @override
  Future<(Failure?, bool?)> isTimeSlotAvailable(
      {required String providerId, required DateTime dateTime}) async {
    try {
      final result = await _dataSource.isTimeSlotAvailable(
          providerId: providerId, dateTime: dateTime);
      return (null, result);
    } on AppointmentException catch (error) {
      return (AppointmentFailure(message: error.message), null);
    } catch (e) {
      return (AppointmentFailure(message: e.toString()), null);
    }
  }

  @override
  Future<(Failure?, void)> updateAppointmentStatus(
      {required String appointmentId, required String status}) async {
    try {
      await _dataSource.updateAppointmentStatus(
          appointmentId: appointmentId, status: status);
      return (null, null);
    } on UpdateAppointmentException catch (error) {
      return (AppointmentFailure(message: error.message), null);
    } catch (e) {
      return (AppointmentFailure(message: e.toString()), null);
    }
  }

  @override
  Stream<(Failure?, List<AppointmentEntity>?)> watchProviderAppointments(
      {required String providerId}) {
    return _dataSource
        .watchProviderAppointments(providerId: providerId)
        .map((appointments) {
      try {
        final entities = appointments.map((model) => model).toList();
        return (null, entities);
      } catch (error) {
        return (AppointmentFailure(message: error.toString()), null);
      }
    });
  }
}
