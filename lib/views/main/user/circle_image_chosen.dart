import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';

class CircleImageChosen extends StatefulWidget {
  final VoidCallback onTap;
  final File? file;
  final String fileUrl;
  const CircleImageChosen({
    super.key, 
    required this.onTap, 
    required this.file, 
    required this.fileUrl
  });

  @override
  State<CircleImageChosen> createState() => _CircleImageChosenState();
}

class _CircleImageChosenState extends State<CircleImageChosen> {
  @override
  Widget build(BuildContext context) {
    if (widget.file != null) {
      return InkWell(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.file(
            widget.file!,
            errorBuilder: (context, error, stackTrace) => Image.network(userDefaultImage),
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            widget.fileUrl,
            errorBuilder: (context, error, stackTrace) => Image.network(userDefaultImage),
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}