import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

    try {
      final pending = await _dbHelper.getPendingParcels();
      if (pending.isEmpty) return;

      int successCount = 0;
      for (var item in pending) {
        final id = item['id'];
        final data = jsonDecode(item['data']);
        
        try {
          await _apiClient.dio.post('/parcels', data: data);
          await _dbHelper.updateParcelStatus(id, 'synced');
          successCount++;
        } catch (e) {
          print('Failed to sync parcel ID $id: $e');
        }
      }

      if (successCount > 0) {
        Fluttertoast.showToast(
          msg: "$successCount fiches synchronisées automatiquement !",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
        );
      }
    } catch (e) {
      print('Sync Error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> syncDrafts() async {
    // This allows manual sync of drafts as well
    final drafts = await _dbHelper.getDrafts();
    for (var item in drafts) {
      final id = item['id'];
      final data = jsonDecode(item['data']);
      try {
        await _apiClient.dio.post('/parcels', data: data);
        await _dbHelper.updateParcelStatus(id, 'synced');
      } catch (e) {
        print('Failed to sync draft ID $id: $e');
      }
    }
  }
}
