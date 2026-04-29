import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/model/category_model.dart';

class CategoriesGridList extends StatefulWidget {
  const CategoriesGridList({super.key});

  @override
  State<CategoriesGridList> createState() => _CategoriesGridListState();
}

class _CategoriesGridListState extends State<CategoriesGridList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: otherServices.getTags(context), 
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(child: Icon(Icons.error, size: 100, color: AppColors.red));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppColors.yellow));
        } else {
          List<CategoryModel> grids = snapshot.data!;
          return Wrap(
            spacing: 4,
            runSpacing: 16,
            children: grids.map((tag) {
              if (tag.tag == "all") return SizedBox();
              return GestureDetector(
                onTap: () => Navigator.push(context, checkDeviceRoute(listofFoodByTag(tag.tag))),
                child: Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(tag.image),
                      fit: BoxFit.cover,
                    )
                  ),
                  child: Container(
                    // ignore: deprecated_member_use
                    color: AppColors.black.withOpacity(0.5),
                    child: Center(
                      child: Text(
                        tag.tag.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}