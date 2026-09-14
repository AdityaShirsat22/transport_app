class NotificationLog {
  final String id;
  final String transportId;
  final String recipientName;
  final String recipientMobile;
  final String channel; // 'WhatsApp', 'SMS'
  final String messageBody;
  final String status; // 'SENT', 'DELIVERED', 'FAILED'
  final DateTime sentAt;

  const NotificationLog({
    required this.id,
    required this.transportId,
    required this.recipientName,
    required this.recipientMobile,
    this.channel = 'WhatsApp',
    required this.messageBody,
    this.status = 'SENT',
    required this.sentAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transportId': transportId,
      'recipientName': recipientName,
      'recipientMobile': recipientMobile,
      'channel': channel,
      'messageBody': messageBody,
      'status': status,
      'sentAt': sentAt.toIso8601String(),
    };
  }

  factory NotificationLog.fromJson(Map<String, dynamic> json) {
    return NotificationLog(
      id: json['id'] as String,
      transportId: json['transportId'] as String,
      recipientName: json['recipientName'] as String,
      recipientMobile: json['recipientMobile'] as String,
      channel: json['channel'] as String? ?? 'WhatsApp',
      messageBody: json['messageBody'] as String,
      status: json['status'] as String? ?? 'SENT',
      sentAt: DateTime.parse(json['sentAt'] as String),
    );
  }
}
