import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:parcello_mobile/core/api/api_client.dart';
import 'package:parcello_mobile/models/stats_model.dart';
import 'package:parcello_mobile/features/auth/providers/auth_provider.dart';

final statsRepositoryProvider = Provider((ref) => StatsRepository(ref.read(apiClientProvider)));

final statsProvider = FutureProvider<DashboardStats>((ref) async {
  // Watch auth state to re-fetch when user changes
  final authState = ref.watch(authStateProvider);
  if (authState.user == null) return DashboardStats.empty();
  
  return ref.read(statsRepositoryProvider).getStats();
});

class StatsRepository {
  final ApiClient _apiClient;

  StatsRepository(this._apiClient);

  Future<DashboardStats> getStats() async {
    try {
      final response = await _apiClient.dio.get('/stats');
      if (response.data['success'] == true) {
        return DashboardStats.fromJson(response.data['stats']);
      }
      return DashboardStats.empty();
    } on DioException catch (e) {
      print('DioError fetching stats: ${e.message}');
      return DashboardStats.empty();
    } catch (e) {
      print('Unexpected error fetching stats: $e');
      return DashboardStats.empty();
    }
  }
}
