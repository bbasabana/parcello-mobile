import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:parcello_mobile/core/api/api_client.dart';
import 'package:parcello_mobile/models/location_model.dart';

final locationRepositoryProvider = Provider((ref) => LocationRepository(ref.read(apiClientProvider)));

final communesProvider = FutureProvider<List<CommuneModel>>((ref) async {
  return ref.read(locationRepositoryProvider).getCommunes();
});

final quartersProvider = FutureProvider.family<List<QuarterModel>, String>((ref, communeName) async {
  return ref.read(locationRepositoryProvider).getQuarters(communeName);
});

class LocationRepository {
  final ApiClient _apiClient;

  LocationRepository(this._apiClient);

  Future<List<CommuneModel>> getCommunes() async {
    try {
      final response = await _apiClient.dio.get('/locations');
      if (response.data['success'] == true) {
        final List list = response.data['communes'];
        return list.map((e) => CommuneModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('DioError fetching communes: ${e.message}');
      return [];
    } catch (e) {
      print('Unexpected error fetching communes: $e');
      return [];
    }
  }

  Future<List<QuarterModel>> getQuarters(String communeName) async {
    try {
      final response = await _apiClient.dio.get('/locations', queryParameters: {'commune': communeName});
      if (response.data['success'] == true) {
        final List list = response.data['quarters'];
        return list.map((e) => QuarterModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('DioError fetching quarters: ${e.message}');
      return [];
    } catch (e) {
      print('Unexpected error fetching quarters: $e');
      return [];
    }
  }
}
