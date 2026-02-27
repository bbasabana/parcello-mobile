import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parcello_mobile/core/theme/app_theme.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  void init() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.first;
      if (result == ConnectivityResult.none) {
        _showToast(
          "Connexion perdue. Vos données seront sauvegardées localement.",
          Colors.red,
        );
      } else {
        _showToast(
          "Connexion rétablie. Synchronisation possible.",
          AppTheme.successGreen,
        );
      }
    });
  }

  void _showToast(String message, Color bgColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
