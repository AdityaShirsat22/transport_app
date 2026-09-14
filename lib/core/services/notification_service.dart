import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/transport/data/transport_repository.dart';
import '../../features/transport/domain/notification_log.dart';
import '../../features/transport/domain/transport_model.dart';

abstract class NotificationService {
  String generateAssignmentMessage(Transport transport);
  Future<NotificationLog> sendVehicleAssignmentNotification(
    Transport transport, {
    String recipientPhone = '',
  });
}

class MockNotificationService implements NotificationService {
  final TransportRepository _transportRepo;

  MockNotificationService(this._transportRepo);

  @override
  String generateAssignmentMessage(Transport transport) {
    return '''Dear Customer,

Your transport vehicle has been assigned.

Vehicle No: ${transport.vehicleNumber ?? 'N/A'}
Container No: ${transport.containerNumber}
Driver Name: ${transport.driverName ?? 'N/A'}
Driver Contact: ${transport.driverMobile ?? 'N/A'}
From: ${transport.fromLocationName}
To: ${transport.toLocationName}
Booking No: ${transport.bookingNumber}

Thank you.''';
  }

  @override
  Future<NotificationLog> sendVehicleAssignmentNotification(
    Transport transport, {
    String recipientPhone = '',
  }) async {
    final message = generateAssignmentMessage(transport);
    final log = NotificationLog(
      id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
      transportId: transport.id,
      recipientName: transport.partyName,
      recipientMobile: recipientPhone.isNotEmpty ? recipientPhone : '9822001122',
      channel: 'WhatsApp',
      messageBody: message,
      status: 'SENT',
      sentAt: DateTime.now(),
    );

    _transportRepo.addNotificationLog(log);
    return log;
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final transportRepo = ref.watch(transportRepositoryProvider);
  return MockNotificationService(transportRepo);
});
