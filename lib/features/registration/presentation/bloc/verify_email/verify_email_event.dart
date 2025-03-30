part of 'verify_email_bloc.dart';

abstract class EmailVerificationEvent extends Equatable {
  const EmailVerificationEvent();

  @override
  List<Object> get props => [];
}

class CheckEmailVerificationEvent extends EmailVerificationEvent {
  const CheckEmailVerificationEvent();
}

class UpdateEmailVerificationEvent extends EmailVerificationEvent {
  const UpdateEmailVerificationEvent();
}
