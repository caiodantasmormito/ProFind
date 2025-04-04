import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/registration/domain/entities/user_entity.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  ProfileBloc({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore,
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(const ProfileError('Usuário não autenticado'));
        return;
      }

      final userDoc = await _getUserDocument(user.uid);
      if (userDoc == null) {
        emit(const ProfileError('Dados do usuário não encontrados'));
        return;
      }

      emit(ProfileLoaded(user: userDoc));
    } catch (e) {
      emit(ProfileError('Erro ao carregar perfil: ${e.toString()}'));
    }
  }

  Future<UserEntity?> _getUserDocument(String userId) async {
    final clientDoc = await _firestore.collection('clients').doc(userId).get();
    if (clientDoc.exists) {
      return UserEntity.fromFirestore(clientDoc, userType: 'client');
    }

    final providerDoc = await _firestore
        .collection('service_providers')
        .doc(userId)
        .get();
    if (providerDoc.exists) {
      return UserEntity.fromFirestore(providerDoc, userType: 'service_provider');
    }

    return null;
  }
}