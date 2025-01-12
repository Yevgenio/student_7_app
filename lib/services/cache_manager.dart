import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomImageCacheManager extends CacheManager {
  static const key = "customImageCache";

  static final instance = CustomImageCacheManager._();

  CustomImageCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 30), // Cache expiry time
            maxNrOfCacheObjects: 200, // Max cache size
          ),
        );
}