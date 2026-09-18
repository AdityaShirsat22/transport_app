import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/transport/data/transport_repository.dart';
import '../../features/transport/domain/pod_document.dart';
import '../config/env_config.dart';

class PodService {
  final TransportRepository _transportRepo;

  PodService(this._transportRepo);

  SupabaseClient? get _client {
    if (EnvConfig.isSupabaseConfigured) {
      try {
        return Supabase.instance.client;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Pick a POD document from Android file storage (PDF or Image)
  Future<File?> pickPodFile() async {
    final result = await FilePickerPlatform.instance.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result.isNotEmpty) {
      final file = result.first;
      if (file.path != null) {
        return File(file.path!);
      }
    }
    return null;
  }

  /// Process POD upload for a transport
  Future<PodDocument> processPodUpload({
    required String transportId,
    required File file,
    String uploadedBy = 'Super Admin',
  }) async {
    final fileName = p.basename(file.path);
    final ext = p.extension(file.path).toLowerCase();
    final fileType = ext == '.pdf' ? 'PDF' : 'IMAGE';
    final fileSize = await file.length();
    final now = DateTime.now();

    // 1. Always cache file locally in app documents
    final docsDir = await getApplicationDocumentsDirectory();
    final podDir = Directory(p.join(docsDir.path, 'pods', transportId));
    if (!await podDir.exists()) {
      await podDir.create(recursive: true);
    }
    final localCopy = await file.copy(p.join(podDir.path, fileName));

    String? cloudUrl;
    final storagePath = 'pods/$transportId/$fileName';

    // 2. Try Supabase Storage upload if online
    final client = _client;
    if (client != null) {
      try {
        final bytes = await localCopy.readAsBytes();
        await client.storage.from('pod-documents').uploadBinary(
              storagePath,
              bytes,
              fileOptions: FileOptions(upsert: true, contentType: ext == '.pdf' ? 'application/pdf' : 'image/jpeg'),
            );
        cloudUrl = client.storage.from('pod-documents').getPublicUrl(storagePath);
      } catch (_) {
        // Handled via local sync queue
      }
    }

    final pod = PodDocument(
      fileName: fileName,
      fileType: fileType,
      fileSize: fileSize,
      uploadedBy: uploadedBy,
      uploadedAt: now,
      fileUrl: cloudUrl,
    );

    // 3. Save to repository & Drift
    _transportRepo.uploadPod(transportId, pod);

    return pod;
  }
}

final podServiceProvider = Provider<PodService>((ref) {
  final transportRepo = ref.watch(transportRepositoryProvider);
  return PodService(transportRepo);
});
