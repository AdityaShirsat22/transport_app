import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/transport_status.dart';
import '../../../shared/mock_data/demo_seed_data.dart';
import '../domain/activity_log.dart';
import '../domain/notification_log.dart';
import '../domain/pod_document.dart';
import '../domain/transport_model.dart';

abstract class TransportRepository {
  List<Transport> getAll();
  Transport? getById(String id);
  Transport? getByBookingNumber(String bookingNumber);
  Transport? getActiveByContainerNumber(String containerNumber);
  void add(Transport transport);
  void update(Transport transport);
  void updateStatus(String transportId, TransportStatus newStatus, {String? exceptionReason});
  void uploadPod(String transportId, PodDocument pod);
  void completeTransport(String transportId);
  void delete(String id);

  // Activity logs
  List<ActivityLog> getActivityLogs(String transportId);
  void addActivityLog(ActivityLog log);

  // Notifications
  List<NotificationLog> getNotificationLogs(String transportId);
  void addNotificationLog(NotificationLog log);
}

class MockTransportRepository implements TransportRepository {
  final List<Transport> _transports = [];
  final List<ActivityLog> _activityLogs = [];
  final List<NotificationLog> _notificationLogs = [];

  MockTransportRepository() {
    _transports.addAll(DemoSeedData.getTransports());
    _activityLogs.addAll(DemoSeedData.getActivityLogs());
    _notificationLogs.addAll(DemoSeedData.getNotificationLogs());
  }

  @override
  List<Transport> getAll() => List.unmodifiable(_transports);

  @override
  Transport? getById(String id) {
    try {
      return _transports.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Transport? getByBookingNumber(String bookingNumber) {
    try {
      return _transports.firstWhere(
        (t) => t.bookingNumber.toLowerCase() == bookingNumber.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Transport? getActiveByContainerNumber(String containerNumber) {
    try {
      return _transports.firstWhere(
        (t) =>
            t.containerNumber.toLowerCase() == containerNumber.trim().toLowerCase() &&
            t.status.isActive,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void add(Transport transport) {
    _transports.insert(0, transport);
  }

  @override
  void update(Transport transport) {
    final index = _transports.indexWhere((t) => t.id == transport.id);
    if (index != -1) {
      _transports[index] = transport;
    }
  }

  @override
  void updateStatus(String transportId, TransportStatus newStatus, {String? exceptionReason}) {
    final index = _transports.indexWhere((t) => t.id == transportId);
    if (index != -1) {
      final current = _transports[index];
      _transports[index] = current.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
        exceptionReason: exceptionReason,
      );
    }
  }

  @override
  void uploadPod(String transportId, PodDocument pod) {
    final index = _transports.indexWhere((t) => t.id == transportId);
    if (index != -1) {
      final current = _transports[index];
      _transports[index] = current.copyWith(
        pod: pod,
        status: TransportStatus.podReceived,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  void completeTransport(String transportId) {
    final index = _transports.indexWhere((t) => t.id == transportId);
    if (index != -1) {
      final current = _transports[index];
      _transports[index] = current.copyWith(
        status: TransportStatus.completed,
        completionDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  void delete(String id) {
    _transports.removeWhere((t) => t.id == id);
  }

  @override
  List<ActivityLog> getActivityLogs(String transportId) {
    return _activityLogs
        .where((log) => log.transportId == transportId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  void addActivityLog(ActivityLog log) {
    _activityLogs.add(log);
  }

  @override
  List<NotificationLog> getNotificationLogs(String transportId) {
    return _notificationLogs
        .where((n) => n.transportId == transportId)
        .toList()
      ..sort((a, b) => b.sentAt.compareTo(a.sentAt));
  }

  @override
  void addNotificationLog(NotificationLog log) {
    _notificationLogs.add(log);
  }
}

final transportRepositoryProvider = Provider<TransportRepository>((ref) {
  return MockTransportRepository();
});
