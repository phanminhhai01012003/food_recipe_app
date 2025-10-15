import 'dart:io';

import 'package:flutter/material.dart';

abstract class ImageRepo {
  Future<void> pickImage(BuildContext context, bool isCamera, File? image);
  Future<void> uploadImage(BuildContext context, File? image, String folder, String imageUrl);
}