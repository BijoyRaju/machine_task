import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/connectivity_service.dart';

class ConnectivityProvider with ChangeNotifier {
  final ConnectivityService _connectivityService = ConnectivityService();
  StreamSubscription<bool>? _connectivitySubscription;
  
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    await _connectivityService.initialize();
    
    _connectivitySubscription = _connectivityService.connectionStatus.listen(
      (isConnected) {
        _isConnected = isConnected;
        notifyListeners();
      },
    );

    // Set initial state
    _isConnected = _connectivityService.isConnected;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityService.dispose();
    super.dispose();
  }
}
