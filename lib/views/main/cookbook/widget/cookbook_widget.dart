import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
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
      onTap: () => Navigator.push(context, checkDeviceRoute(cookbookDetail(widget.book))),
      child: Container(
        height: 75,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(widget.book.cookbookImage),
            fit: BoxFit.cover
          ),
        ),
        child: Container(
          // ignore: deprecated_member_use
          color: AppColors.black.withOpacity(0.5),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              widget.book.cookbookName,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}