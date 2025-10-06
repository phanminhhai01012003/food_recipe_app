import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';

class CookbookWidget extends StatefulWidget {
  final CookbookModel book;
  const CookbookWidget({super.key, required this.book});

  @override
  State<CookbookWidget> createState() => _CookbookWidgetState();
}

class _CookbookWidgetState extends State<CookbookWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(widget.book.cookbookImage),
            colorFilter: ColorFilter.mode(
              // ignore: deprecated_member_use
              AppColors.black.withOpacity(0.5),  
              BlendMode.dstATop
            )
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.book.cookbookName,
              style: TextStyle(
                color: AppColors.white,
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