import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';

class CookbookList extends StatefulWidget {
  final CookbookModel cookbook;
  const CookbookList({super.key, required this.cookbook});

  @override
  State<CookbookList> createState() => _CookbookListState();
}

class _CookbookListState extends State<CookbookList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: AppColors.white,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.cookbook.cookbookImage,
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                    color: AppColors.yellow,
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}