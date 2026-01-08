import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:pdfx/pdfx.dart';

class FullScreenWidget extends StatefulWidget {
  final String imageUrl;
  const FullScreenWidget({super.key, required this.imageUrl});

  @override
  State<FullScreenWidget> createState() => _FullScreenWidgetState();
}

class _FullScreenWidgetState extends State<FullScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: CachedNetworkImageProvider(
        widget.imageUrl,
        scale: 1.0,
      ),
      maxScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * 4,
      loadingBuilder: (context, event) => Center(
        child: CircularProgressIndicator(
          color: AppColors.yellow,
          value: event == null ? null : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
        )
      ),
      errorBuilder: (context, error, stackTrace) => Center(
        child: Icon(
          Icons.error, 
          size: 20,
          color: AppColors.grey,
        ),
      ),
      gestureDetectorBehavior: HitTestBehavior.translucent,
      basePosition: Alignment.center,
      filterQuality: FilterQuality.medium,
    );
  }
}