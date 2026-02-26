import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/database_helper.dart';
import '../api/api_client.dart';

class SyncService {
  final ApiClient _apiClient;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  SyncService(this._apiClient);

  void start() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        syncPendingParcels();
      }
    });
    
    // Initial check
    syncPendingParcels();
    
    // Periodic check every 5 minutes
    Timer.periodic(const Duration(minutes: 5), (_) => syncPendingParcels());
  }

  void stop() {
    _connectivitySubscription?.cancel();
  }

  Future<void> syncPendingParcels() async {
    if (_isSyncing) return;
    
    final results = await Connectivity().checkConnectivity();
    if (results.every((result) => result == ConnectivityResult.none)) return;

    _isSyncing = true;
    print('Starting background sync...');

    try {
      final pending = await _dbHelper.getPendingParcels();
      for (var item in pending) {
        final id = item['id'];
        final data = jsonDecode(item['data']);
        
        try {
          await _apiClient.dio.post('/parcels', data: data);
          await _dbHelper.updateParcelStatus(id, 'synced');
          print('Successfully synced parcel ID: $id');
        } catch (e) {
          print('Failed to sync parcel ID $id: $e');
        }
      }
    } catch (e) {
      print('Sync Error: $e');
    } finally {
      _isSyncing = false;
    }
  }
}
