import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profind/features/service_providers/data/datasources/service_providers_datasource.dart';
import 'package:profind/features/service_providers/data/models/service_provider_model.dart';

final class ServiceProvidersDatasourceImpl implements ServiceProvidersDatasource {
  final FirebaseFirestore _firestore;

  ServiceProvidersDatasourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ServiceProviderModel>> getServiceProviders() async {
    try {
      final querySnapshot = await _firestore
          .collection('service_providers')
          .where('userType', isEqualTo: 'service_provider')
          
          .get();

      return querySnapshot.docs.map((doc) {
        return ServiceProviderModel.fromJson({
          'id': doc.id,
          ...doc.data(), 
        });
      }).toList();
    } on FirebaseException catch (e) {
      throw Exception('Erro ao buscar prestadores: ${e.message}');
    } catch (e) {
      throw Exception('Falha inesperada: $e');
    }
  }

  
}