import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:parcello_mobile/core/api/api_client.dart';
import 'package:parcello_mobile/models/parcel_model.dart';

final parcelRepositoryProvider = Provider((ref) => ParcelRepository(ref.read(apiClientProvider)));

final userParcelsProvider = FutureProvider<List<ParcelModel>>((ref) async {
  return ref.read(parcelRepositoryProvider).getParcels();
});

class ParcelRepository {
  final ApiClient _apiClient;

  ParcelRepository(this._apiClient);

  Future<List<ParcelModel>> getParcels() async {
    try {
      final response = await _apiClient.dio.get('/parcels');
      if (response.data['success'] == true) {
        final List list = response.data['parcels'];
        return list.map((e) => ParcelModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('DioError fetching parcels: ${e.message}');
      return [];
    } catch (e) {
      print('Unexpected error fetching parcels: $e');
      return [];
    }
  }
}
