import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../../constants.dart' as constants;

class CachedImageWidget extends StatelessWidget {
  final String bucket_id, image_id;
  CachedImageWidget(
      {super.key, required this.image_id, required this.bucket_id});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ClipOval(
      // borderRadius: BorderRadius.circular(20), // Image border
      child: SizedBox.fromSize(
        size: const Size.fromRadius(48), // Image radius
        child: cachedImage(bucket_id, image_id),
      ),
    );
  }

  Future<Uint8List?> _getCachedImage(String bucketId, String fileId) async {
    final cacheManager = DefaultCacheManager();
    final fileInfo = await cacheManager.getFileFromCache(fileId);

    if (fileInfo != null && await fileInfo.file.exists() != false) {
      // File is already cached
      return fileInfo.file.readAsBytes();
    } else {
      // File is not cached, fetch it and cache it
      // final fileBytes =
      //     await storage.getFileView(bucketId: bucketId, fileId: fileId);
      // if (fileBytes.isNotEmpty) {
      //   await cacheManager.putFile(fileId, fileBytes);
      // }
      // return fileBytes;
    }
  }

  Widget cachedImage(String image_url, String image_id) {
    return CachedNetworkImage(
      width: 60.0,
      height: 60.0,
      fit: BoxFit.cover,
      imageUrl: image_url,
      errorWidget: _error,
      progressIndicatorBuilder: _progressIndicator,
    );
  }

  Widget _progressIndicator(
      BuildContext context, String url, downloadProgress) {
    return Center(
      child: CircularProgressIndicator(value: downloadProgress.progress),
    );
  }

  Widget _error(BuildContext context, String url, Object error) {
    return const Center(child: Icon(Icons.error));
  }
}
