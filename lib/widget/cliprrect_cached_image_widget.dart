import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ClipRRectCachedImageWidget extends StatelessWidget {
  final String image_id;
  ClipRRectCachedImageWidget({super.key, required this.image_id});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Image border
      child: Stack(
        children: [
          SizedBox.fromSize(
            child: cachedImage(image_id),
          ),
        ],
      ),
    );
  }

  Widget cachedImage(String image_url) {
    log('image_url $image_url');
    return CachedNetworkImage(
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
