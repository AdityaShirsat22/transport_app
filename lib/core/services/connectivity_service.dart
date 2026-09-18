import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _onlineController = StreamController<bool>.broadcast();
  StreamSubscription<dynamic>? _subscription;

  ConnectivityService() {
    _init();
  }

  Stream<bool> get onConnectivityChanged => _onlineController.stream;

  Future<bool> checkOnline() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _isResultOnline(results);
    } catch (_) {
      // Default to online if platform channel is missing or unlinked
      return true;
    }
  }

  void _init() {
    // Initial probe
    checkOnline().then((online) {
      if (!_onlineController.isClosed) {
        _onlineController.add(online);
      }
    }).catchError((_) {
      if (!_onlineController.isClosed) {
        _onlineController.add(true);
      }
    });

    try {
      _subscription = _connectivity.onConnectivityChanged.listen(
        (results) {
          if (!_onlineController.isClosed) {
            _onlineController.add(_isResultOnline(results));
          }
        },
        onError: (error) {
          // Gracefully absorb MissingPluginException on platforms without native linkage
          if (!_onlineController.isClosed) {
            _onlineController.add(true);
          }
        },
        cancelOnError: false,
      );
    } catch (_) {
      if (!_onlineController.isClosed) {
        _onlineController.add(true);
      }
    }
  }

  bool _isResultOnline(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) => r != ConnectivityResult.none);
  }

  void dispose() {
    _subscription?.cancel();
    _onlineController.close();
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final isOnlineStreamProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
});
