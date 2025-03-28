import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profind/features/registration/data/datasource/registration_datasource.dart';
import 'package:profind/features/registration/data/exceptions/exceptions.dart';
import 'package:profind/features/registration/data/models/client_model.dart';
import 'package:profind/features/registration/data/models/service_provider_model.dart';

final class RegistrationDataSourceImpl implements RegistrationDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  RegistrationDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<ServiceProviderModel> registerServiceProvider({
    required ServiceProviderModel serviceProviderModel,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: serviceProviderModel.email,
        password: password,
      );

      final String userId = userCredential.user!.uid;

      final Map<String, dynamic> userData = {
        'id': userId,
        'name': serviceProviderModel.name,
        'surname': serviceProviderModel.surname,
        'cpf': serviceProviderModel.cpf,
        'email': serviceProviderModel.email,
        'city': serviceProviderModel.city,
        'uf': serviceProviderModel.uf,
        'cep': serviceProviderModel.cep,
        'service': serviceProviderModel.service,
        'userType': 'service_provider',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('service_provider').doc(userId).set(userData);

      return ServiceProviderModel(
        id: userId,
        name: serviceProviderModel.name,
        surname: serviceProviderModel.surname,
        cpf: serviceProviderModel.cpf,
        email: serviceProviderModel.email,
        city: serviceProviderModel.city,
        uf: serviceProviderModel.uf,
        cep: serviceProviderModel.cep,
        service: serviceProviderModel.service,
      );
    } on FirebaseAuthException catch (e) {
      throw RegisterException(message: e.message ?? "Falha no cadastro.");
    } on FirebaseException catch (e) {
      throw RegisterException(
          message: e.message ?? "Falha ao salvar dados adicionais.");
    }
  }

  @override
  Future<ClientModel> registerClient({required ClientModel clientModel, required String password}) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: clientModel.email,
        password: password,
      );

      final String userId = userCredential.user!.uid;

      final Map<String, dynamic> userData = {
        'id': userId,
        'name': clientModel.name,
        'surname': clientModel.surname,
        'cpf': clientModel.cpf,
        'email': clientModel.email,
        'city': clientModel.city,
        'uf': clientModel.uf,
        'cep': clientModel.cep,
        
        'userType': 'client',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('client').doc(userId).set(userData);

      return ClientModel(
        id: userId,
        name: clientModel.name,
        surname: clientModel.surname,
        cpf: clientModel.cpf,
        email: clientModel.email,
        city: clientModel.city,
        uf: clientModel.uf,
        cep: clientModel.cep,
        
      );
    } on FirebaseAuthException catch (e) {
      throw RegisterException(message: e.message ?? "Falha no cadastro.");
    } on FirebaseException catch (e) {
      throw RegisterException(
          message: e.message ?? "Falha ao salvar dados adicionais.");
    }
  }
}
