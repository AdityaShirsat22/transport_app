class PodDocument {
  final String fileName;
  final String fileType; // 'IMAGE' or 'PDF'
  final int fileSize;
  final String uploadedBy;
  final DateTime uploadedAt;
  final String? fileUrl;

  const PodDocument({
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    this.uploadedBy = 'Super Admin',
    required this.uploadedAt,
    this.fileUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
      'uploadedBy': uploadedBy,
      'uploadedAt': uploadedAt.toIso8601String(),
      'fileUrl': fileUrl,
    };
  }

  factory PodDocument.fromJson(Map<String, dynamic> json) {
    return PodDocument(
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
      fileSize: json['fileSize'] as int,
      uploadedBy: json['uploadedBy'] as String? ?? 'Super Admin',
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      fileUrl: json['fileUrl'] as String?,
    );
  }
}
