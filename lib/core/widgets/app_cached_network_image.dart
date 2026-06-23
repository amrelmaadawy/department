import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Widget Function(BuildContext, String, DownloadProgress)? progressIndicatorBuilder;
  final Widget Function(BuildContext, String)? placeholder;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.errorWidget,
    this.progressIndicatorBuilder,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    
    // Calculate optimal cache dimensions to prevent memory leaks from oversized images
    // If no width/height provided, default to a safe maximum width of 800 physical pixels
    int? cacheWidth;
    int? cacheHeight;

    if (width != null && width != double.infinity) {
      cacheWidth = (width! * devicePixelRatio).toInt();
    } else if (height != null && height != double.infinity) {
      cacheHeight = (height! * devicePixelRatio).toInt();
    } else {
      cacheWidth = 800; // Safe default for full-screen unconstrained images
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      errorWidget: errorWidget,
      progressIndicatorBuilder: progressIndicatorBuilder,
      placeholder: placeholder,
    );
  }
}
