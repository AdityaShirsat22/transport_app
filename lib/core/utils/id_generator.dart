class IdGenerator {
  static int _transportCounter = 129;
  static int _bookingCounter = 4050;

  static String generateTransportId() {
    _transportCounter++;
    final formatted = _transportCounter.toString().padLeft(5, '0');
    return 'TR-$formatted';
  }

  static String generateBookingNumber() {
    _bookingCounter++;
    return 'BK${DateTime.now().year}-$_bookingCounter';
  }
}
