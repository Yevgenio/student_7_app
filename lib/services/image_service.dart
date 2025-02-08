import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:student_7_app/services/cache_manager.dart';
import '../config.dart';

class ImageService {
  static const String uploadUrl = '${ServerAPI.baseUrl}/api/uploads';

  // Combine constructing the URL and caching it
  static Future<String> getProcessedImageUrl(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return '$uploadUrl/default';
    } else if (Uri.tryParse(imagePath)?.hasAbsolutePath ?? false) {
      return imagePath;
    } else {
      return '$uploadUrl/$imagePath';
    }
  }

  static Future<void> clearCacheForImage(String imageUrl) async {
    await CustomImageCacheManager.instance.removeFile(imageUrl);
  }

  static Future<void> clearAllImageCache() async {
    await CustomImageCacheManager.instance.emptyCache();
  }
}
