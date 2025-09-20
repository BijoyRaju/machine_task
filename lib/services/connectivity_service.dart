import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  // Initialize the Connectivity method
  Future<void> initialize() async {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    final connectivityResults = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResults);
  }

  // Update the connection status
  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    bool isConnected = connectivityResults.any((result) => 
        result == ConnectivityResult.mobile || 
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);
    
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      _connectionStatusController.add(isConnected);
    }
  }

  // Dispose the stream when no longer needed
  void dispose() {
    _connectionStatusController.close();
  }
}
