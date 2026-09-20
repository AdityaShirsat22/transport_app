class IdGenerator {
  static int _transportCounter = 0;
  static int _bookingCounter = 4050;

  static void resetForTesting() {
    _transportCounter = 0;
    _bookingCounter = 4050;
  }

  /// Syncs the transport counter with existing IDs so new IDs continue seamlessly.
  static void syncTransportCounter(Iterable<String> existingIds) {
    for (final id in existingIds) {
      if (id.startsWith('TR-')) {
        final numStr = id.substring(3);
        // Ignore the legacy hardcoded dummy value '00130' or '130' if present
        if (numStr == '00130' || numStr == '130') continue;
        final val = int.tryParse(numStr);
        if (val != null && val > _transportCounter) {
          _transportCounter = val;
        }
      }
    }
  }

  static String generateTransportId() {
    _transportCounter++;
    final formatted = _transportCounter.toString().padLeft(2, '0');
    return 'TR-$formatted';
  }

  static String generateBookingNumber() {
    _bookingCounter++;
    return 'BK${DateTime.now().year}-$_bookingCounter';
  }
}
