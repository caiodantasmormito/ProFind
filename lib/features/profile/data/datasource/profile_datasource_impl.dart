import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/features/profile/data/datasource/profile_datasource.dart';
import 'package:profind/features/profile/data/exceptions/exceptions.dart';
import 'package:profind/features/registration/data/models/user_model.dart';

final class ProfileDataSourceImpl implements ProfileDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  ProfileDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final clientDoc =
          await _firestore.collection('clients').doc(userId).get();
      if (clientDoc.exists) {
        return UserModel.fromJson({...clientDoc.data()!, 'userType': 'client'});
      }

      final providerDoc =
          await _firestore.collection('service_providers').doc(userId).get();
      if (providerDoc.exists) {
        return UserModel.fromJson(
            {...providerDoc.data()!, 'userType': 'service_provider'});
      }

      throw ProfileException(message: 'Usuário não encontrado');
    } on FirebaseException catch (e) {
      throw ProfileException(
          message:
              'Erro ao buscar perfil: ${e.message ?? "Erro desconhecido"}');
    }
  }

  @override
  Future<void> updateUserProfile(UserModel userModel) async {
    try {
      final collection =
          userModel.userType == 'client' ? 'clients' : 'service_providers';

      await _firestore.collection(collection).doc(userModel.id).update({
        'name': userModel.name,
        'surname': userModel.surname,
        'phone': userModel.phone,
        'city': userModel.city,
        'uf': userModel.uf,
        'cep': userModel.cep,
        'address': userModel.address,
        if (userModel.userType == 'service_provider')
          'service': userModel.service,
      });
    } on FirebaseException catch (e) {
      throw ProfileException(
          message:
              'Erro ao atualizar perfil: ${e.message ?? "Erro desconhecido"}');
    }
  }
}
