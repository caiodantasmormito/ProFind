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

      final String userId = userCredential.user!.uid;

      final Map<String, dynamic> userData = {
        'id': userId,
        'name': userModel.name,
        'surname': userModel.surname,
        'cpf': userModel.cpf,
        'email': userModel.email,
        'city': userModel.city,
        'uf': userModel.uf,
        'cep': userModel.cep,
        'userType': userModel.userType,
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (userModel.userType == 'service_provider') {
        if (userModel.service == null) {
          throw RegisterException(
              message: "Serviço é obrigatório para prestadores");
        }
        userData['service'] = userModel.service;
      }

      await _firestore.collection('users').doc(userId).set(userData);

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
      );
    } on FirebaseAuthException catch (e) {
      throw RegisterException(message: e.message ?? "Falha no cadastro.");
    } on FirebaseException catch (e) {
      throw RegisterException(
          message: e.message ?? "Falha ao salvar dados adicionais.");
    }
  }

  @override
  Future<bool> verifyCpfExists(String cpf) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('cpf', isEqualTo: cpf)
          .limit(1)
          .get();
      return query.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw RegisterException(message: e.message ?? "Falha ao verificar CPF.");
    }
  }
}
