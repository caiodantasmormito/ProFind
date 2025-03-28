import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:profind/core/infra/http_client.dart';
import 'package:profind/features/address/data/datasource/get_address_datasource.dart';
import 'package:profind/features/address/data/exceptions/exceptions.dart';
import 'package:profind/features/address/data/models/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class GetAddressDatasourceImpl implements GetAddressDatasource {
  const GetAddressDatasourceImpl(
      {required this.client, required this.localStorage});
  final HttpClient client;
  final SharedPreferences localStorage;

  @override
  Future<AddressModel> getAddress({required String cep}) async {
    try {
      final Response result =
          await client.get('https://viacep.com.br/ws/$cep/json/');

      return AddressModel.fromMap(result.data);
    } on DioException catch (e, s) {
      if (kDebugMode) {
        debugPrintStack(label: e.toString(), stackTrace: s);
      }
      throw const GetAddressException(
          message: 'Falha ao buscar dados do endereço');
    } catch (e, s) {
      if (kDebugMode) {
        debugPrintStack(label: e.toString(), stackTrace: s);
      }
      throw const GetAddressException(message: 'Erro inesperado');
    }
  }
}
