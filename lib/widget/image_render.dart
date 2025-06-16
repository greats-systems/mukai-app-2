import 'dart:developer';
import 'dart:typed_data';
import 'package:mukai/constants.dart';
import 'package:mukai/theme/theme.dart';
import 'package:flutter/material.dart';

class RenderImageIdWidget extends StatelessWidget {
  final String bucket_id, image_id;
  RenderImageIdWidget(
      {super.key, required this.image_id, required this.bucket_id});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: _getCachedImage(bucket_id, image_id),
      builder: (context, snapshot) {
        return snapshot.hasData && snapshot.data != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: Stack(
                  children: [
                    SizedBox.fromSize(
                      size: Size.fromHeight(height), // Image size
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(
                strokeWidth: 1,
                value: 2,
                color: recColor,
              );
      },
    );
  }

  Future<Uint8List?> _getCachedImage(String bucketId, String fileId) async {
    try {
      String filePath = fileId.split('/images/').last;
      String finalPath = filePath.split('product_images/').last;
      log('bucketId: $bucketId\nfilePath: $filePath\n finalPath: $finalPath');
      final data = await supabase.storage.from(bucketId).download(filePath);
      return data;
    } catch (e, s) {
      log('_getCachedImage error: $e $s');
    }
    return null;
    /*
    final cacheManager = DefaultCacheManager();
    final fileInfo = await cacheManager.getFileFromCache(fileId);

    if (fileInfo != null && await fileInfo.file.exists() != false) {
      // File is already cached
      return fileInfo.file.readAsBytes();
    } else {
      // File is not cached, fetch it and cache it
      final fileBytes =
          await storage.getFileView(bucketId: bucketId, fileId: fileId);
      if (fileBytes.isNotEmpty) {
        await cacheManager.putFile(fileId, fileBytes);
      }
      */
    // return fileBytes;
  }
}
