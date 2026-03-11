import 'dart:io';

import 'package:flutter/material.dart';

abstract class ImageRepo {
  Future<File?> pickImage(BuildContext context, bool isCamera);
  Future<File?> pickVideo(BuildContext context, bool isVideo);
  Future<String> uploadImage(BuildContext context, File? image, String folder);
  Future<void> downloadImage(BuildContext context, String imageUrl);
  Future<void> downloadVideo(BuildContext context, String videoUrl);
}