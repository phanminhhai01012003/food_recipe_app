import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:video_player/video_player.dart';

class EditFileChosen extends StatefulWidget {
  final VideoPlayerController? controller;
  final File? file;
  final String fileUrl;
  final VoidCallback onTap;
  const EditFileChosen({
    super.key,
    this.controller,
    required this.file,
    required this.fileUrl,
    required this.onTap,
  });

  @override
  State<EditFileChosen> createState() => _EditFileChosenState();
}

class _EditFileChosenState extends State<EditFileChosen> {
  @override
  Widget build(BuildContext context) {
    bool isImageFile = widget.file.toString().contains("png") || widget.file.toString().contains("jpg") || widget.file.toString().contains("jpeg");
    bool isImageUrl = widget.fileUrl.contains("png") || widget.fileUrl.contains("jpg") || widget.fileUrl.contains("jpeg");
    if (widget.file != null) {
      return InkWell(
        onTap: widget.onTap,
        child: isImageFile ? Image.file(
          widget.file!,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.network(foodDefaultImage),
        ) : AspectRatio(
          aspectRatio: widget.controller!.value.aspectRatio,
          child: VideoPlayer(widget.controller!),
        ),
      );
    } else {
      return InkWell(
        onTap: widget.onTap,
        child: isImageUrl ? Image.network(
          widget.fileUrl,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.network(foodDefaultImage),
        ) : AspectRatio(
          aspectRatio: widget.controller!.value.aspectRatio,
          child: VideoPlayer(widget.controller!),
        ),
      );
    }
  }
}