import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verify_email_event.dart';
part 'verify_email_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  EmailVerificationBloc({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(EmailVerificationInitial()) {
    on<CheckEmailVerificationEvent>(_checkEmailVerification);
    on<UpdateEmailVerificationEvent>(_updateEmailVerification);
  }

  Future<void> _checkEmailVerification(
    CheckEmailVerificationEvent event,
    Emitter<EmailVerificationState> emit,
  ) async {
    emit(EmailVerificationLoading());
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          emit(EmailVerified());
        } else {
          emit(EmailNotVerified());
        }
      }
    } catch (e) {
      emit(EmailVerificationError(e.toString()));
    }
  }

  Future<void> _updateEmailVerification(
    UpdateEmailVerificationEvent event,
    Emitter<EmailVerificationState> emit,
  ) async {
    emit(EmailVerificationLoading());
    try {
      final user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        final batch = _firestore.batch();

        final clientRef = _firestore.collection('clients').doc(user.uid);
        batch.update(clientRef, {'emailVerified': true});

        final providerRef =
            _firestore.collection('service_providers').doc(user.uid);
        batch.update(providerRef, {'emailVerified': true});

        await batch.commit();
        emit(EmailVerified());
      }
    } catch (e) {
      emit(EmailVerificationError(e.toString()));
    }
  }
}
