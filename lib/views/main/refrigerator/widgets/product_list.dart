import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/ingredient_model.dart';

class ProductList extends StatefulWidget {
  final IngredientModel ingredient;
  const ProductList({super.key, required this.ingredient});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: (){},
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary,
              offset: Offset(5, 5),
              blurRadius: 5,
              spreadRadius: 5,
              blurStyle: BlurStyle.solid
            ),
            BoxShadow(
              color: theme.colorScheme.primary,
              offset: Offset(4, 2),
              blurRadius: 3,
              spreadRadius: 3,
              blurStyle: BlurStyle.solid
            )
          ]
        ),
        child: Row(
          children: [
            Hero(
              tag: widget.ingredient.ingredientImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                  imageUrl: widget.ingredient.ingredientImage,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                      color: AppColors.yellow,
                    )
                  ),
                  fadeInCurve: Curves.linear,
                  fadeInDuration: Duration(seconds: 2),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      Icons.error, 
                      size: 20,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.ingredient.ingredientName,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: 10),
            Text(
              "${"originalAmount".tr()}: ${widget.ingredient.originalAmount}${widget.ingredient.unit}",
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: 5),
            Text(
              "${"mfg".tr()}: ${widget.ingredient.mfg}",
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 12,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: 5),
            Text(
              "${"exp".tr()}: ${widget.ingredient.exp}",
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 12,
                fontWeight: FontWeight.w700
              ),
            ),
              ],
            )
          ],
        ),
      ),
    );
  }
}