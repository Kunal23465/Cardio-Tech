import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class DownloadEkgReportService {
  Future<bool> downloadEkgReport(String fileUrl) async {
    try {
      // ✅ Request storage permission for Android
      if (Platform.isAndroid) {
        final storageStatus = await Permission.manageExternalStorage.request();
        if (!storageStatus.isGranted) {
          print("⚠️ Storage permission not granted");
          return false;
        }
      }

      // ✅ Get the appropriate download directory
      Directory downloadDir;
      if (Platform.isAndroid) {
        downloadDir = Directory('/storage/emulated/0/Download');
      } else {
        downloadDir = await getApplicationDocumentsDirectory();
      }

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // ✅ Start download with visible progress in notification area
      final taskId = await FlutterDownloader.enqueue(
        url: fileUrl,
        savedDir: downloadDir.path,
        showNotification: true, // native progress notification
        openFileFromNotification: true, // allow open on click
        saveInPublicStorage: true, // for Android public folder
      );

      if (taskId == null) {
        print("❌ Failed to enqueue download");
        return false;
      }

      print("✅ Download started successfully (taskId: $taskId)");
      return true;
    } catch (e, stack) {
      print("💥 Download error: $e");
      print(stack);
      return false;
    }
  }
}
