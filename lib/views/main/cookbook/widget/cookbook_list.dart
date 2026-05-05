import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/food/cookbook_model.dart';
import 'package:food_recipe_app/model/food/food_model.dart';

class CookbookList extends StatefulWidget {
  final CookbookModel cookbook;
  final FoodModel food;
  const CookbookList({super.key, required this.cookbook, required this.food});

  @override
  State<CookbookList> createState() => _CookbookListState();
}

class _CookbookListState extends State<CookbookList> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      surfaceTintColor: theme.colorScheme.primary,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.cookbook.foodsList.contains(widget.food) ? AppColors.green : theme.colorScheme.primary,
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
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                errorWidget: (context, url, error) => Center(
                  child: Icon(
                    Icons.error,
                    size: 20,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              widget.cookbook.cookbookName,
              style: TextStyle(
                color: widget.cookbook.foodsList.contains(widget.food) ? AppColors.white : theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
}