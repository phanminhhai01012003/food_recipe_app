import 'dart:io';

import 'package:flutter/material.dart';

abstract class ImageRepo {
  Future<File?> pickImage(BuildContext context, bool isCamera);
  Future<String> uploadImage(BuildContext context, File? image, String folder);
}