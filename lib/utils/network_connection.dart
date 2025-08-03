import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NetworkConnection {
  static NetworkConnection? _instance;

  NetworkConnection._();

  static NetworkConnection get instance => _instance ??= NetworkConnection._();

  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResults = await (Connectivity().checkConnectivity());
      if (connectivityResults.isNotEmpty) {
        final connectivityResult = connectivityResults.first;
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          return true;
        }
      }

      return false;
    } on PlatformException {
      return false;
    } catch (e) {
      return false;
    }
  }
}
