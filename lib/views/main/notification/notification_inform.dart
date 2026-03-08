import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';

class NotificationInform extends StatefulWidget {
  final String title;
  final String body;
  final String? androidImageUrl;
  final String? iosImageUrl;
  const NotificationInform({
    super.key,
    required this.title,
    required this.body,
    this.androidImageUrl,
    this.iosImageUrl
  });

  @override
  State<NotificationInform> createState() => _NotificationInformState();
}

class _NotificationInformState extends State<NotificationInform> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: Platform.isAndroid 
                    ? (widget.androidImageUrl ?? foodDesignImage) 
                    : (widget.iosImageUrl ?? foodDesignImage),
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                      color: AppColors.yellow,
                    )
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      Icons.error,
                      size: 30,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle
                    ),
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context), 
                      icon: Icon(
                        Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                        size: 20,
                        color: AppColors.white,
                      )
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.body,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}