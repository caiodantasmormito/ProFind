import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/features/registration/data/datasource/registration_datasource.dart';
import 'package:profind/features/registration/data/exceptions/exceptions.dart';
import 'package:profind/features/registration/data/models/user_model.dart';

final class RegistrationDataSourceImpl implements RegistrationDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  RegistrationDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> registerUser({
    required UserModel userModel,
    required String password,
  }) async {
    try {
      if (userModel.userType != 'client' &&
          userModel.userType != 'service_provider') {
        throw RegisterException(message: "Tipo de usuário inválido");
      }

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
      );

      final User user = userCredential.user!;
      final String userId = user.uid;

      await user.sendEmailVerification();

      final Map<String, dynamic> userData = {
        'id': userId,
        'name': userModel.name,
        'surname': userModel.surname,
        'phone': userModel.phone,
        'cpf': userModel.cpf,
        'email': userModel.email,
        'city': userModel.city,
        'uf': userModel.uf,
        'cep': userModel.cep,
        'userType': userModel.userType,
        'emailVerified': userModel.emailVerified,
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (userModel.userType == 'service_provider') {
        if (userModel.service == null) {
          throw RegisterException(
              message: "Serviço é obrigatório para prestadores");
        }
        userData['service'] = userModel.service;
      }

      final String collectionName =
          userModel.userType == 'client' ? 'clients' : 'service_providers';

      await _firestore.collection(collectionName).doc(userId).set(userData);

      return UserModel(
        id: userId,
        name: userModel.name,
        surname: userModel.surname,
        cpf: userModel.cpf,
        email: userModel.email,
        city: userModel.city,
        uf: userModel.uf,
        cep: userModel.cep,
        phone: userModel.phone,
        address: userModel.address,
        service: userModel.service,
        userType: userModel.userType,
        emailVerified: userModel.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw RegisterException(message: e.message ?? "Falha no cadastro.");
    } on FirebaseException catch (e) {
      throw RegisterException(
          message: e.message ?? "Falha ao salvar dados adicionais.");
    }
  }

  @override
  Future<bool> verifyCpf(String cpf) async {
    try {
      final clientQuery = await _firestore
          .collection('clients')
          .where('cpf', isEqualTo: cpf)
          .limit(1)
          .get();

      if (clientQuery.docs.isNotEmpty) return true;

      final providerQuery = await _firestore
          .collection('service_providers')
          .where('cpf', isEqualTo: cpf)
          .limit(1)
          .get();

      return providerQuery.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw RegisterException(message: e.message ?? "Falha ao verificar CPF.");
    }
  }

  @override
  Future<void> checkAndUpdateEmailVerification(String userId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw RegisterException(message: "Usuário não autenticado");
      }

      if (user.uid != userId) {
        throw RegisterException(message: "ID do usuário não corresponde");
      }

      await user.reload();

      if (user.emailVerified) {
        final clientDoc =
            await _firestore.collection('clients').doc(userId).get();
        final providerDoc =
            await _firestore.collection('service_providers').doc(userId).get();

        if (clientDoc.exists) {
          await _firestore.collection('clients').doc(userId).update({
            'emailVerified': true,
            'emailVerifiedAt': FieldValue.serverTimestamp(),
          });
        } else if (providerDoc.exists) {
          await _firestore.collection('service_providers').doc(userId).update({
            'emailVerified': true,
            'emailVerifiedAt': FieldValue.serverTimestamp(),
          });
        } else {
          throw RegisterException(
              message: "Usuário não encontrado nas coleções");
        }
      }
    } on FirebaseAuthException catch (e) {
      throw RegisterException(message: e.message ?? "Erro na autenticação");
    } on FirebaseException catch (e) {
      throw RegisterException(
          message: e.message ?? "Falha ao verificar e-mail");
    }
  }
}
