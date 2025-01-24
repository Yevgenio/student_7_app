import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:student_7_app/services/cache_manager.dart';
import '../services/image_service.dart';

class CachedImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CachedImage({
    Key? key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return Image.network(
  //     imagePath,
  //     height: height,
  //     width: width,
  //     fit: fit,
  //     errorBuilder: (context, error, stackTrace) => Container(
  //       height: height,
  //       color: Colors.grey[300],
  //       child: const Center(child: Icon(Icons.image, color: Colors.grey)),
  //     ),
  //   );KiSw
  // }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Image.network(
            imagePath,
            height: height,
            width: width,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => Container(
              height: height,
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.image, color: Colors.grey)),
            ),
          )
        : CachedNetworkImage(
            imageUrl: imagePath,
            placeholder: (context, url) {
              //print("Loading placeholder for $url");
              return const Center(child: CircularProgressIndicator());
            },
            errorWidget: (context, url, error) {
              //print("Error loading $url: $error");
              return const Icon(Icons.error);
            },
            imageBuilder: (context, imageProvider) {
              //print("Successfully loaded from cache or network: $imagePath");
              return Image(
                image: imageProvider,
                width: width,
                height: height,
                fit: fit,
              );
            },
            cacheManager:
                CustomImageCacheManager.instance, // Optional for custom caching
          );
  }
}
