part of 'verify_email_bloc.dart';
abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}
class EmailVerificationLoading extends EmailVerificationState {}
class EmailVerified extends EmailVerificationState {}
class EmailNotVerified extends EmailVerificationState {}
class EmailVerificationError extends EmailVerificationState {
  final String message;
  EmailVerificationError(this.message);
}