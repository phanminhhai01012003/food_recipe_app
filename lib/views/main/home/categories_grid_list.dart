import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/category_model.dart';
import 'package:food_recipe_app/views/main/categories/tag_services.dart';

class CategoriesGridList extends StatefulWidget {
  const CategoriesGridList({super.key});

  @override
  State<CategoriesGridList> createState() => _CategoriesGridListState();
}

class _CategoriesGridListState extends State<CategoriesGridList> {
  final _tagServices = TagServices();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _tagServices.getTags(context), 
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(child: Icon(Icons.error, size: 100, color: AppColors.red));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppColors.yellow));
        } else {
          List<CategoryModel> grids = snapshot.data!;
          return GridView.builder(
            hitTestBehavior: HitTestBehavior.translucent,
            clipBehavior: Clip.hardEdge,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.3
            ),
            itemCount: grids.length, 
            itemBuilder: (context, index) {
              final tag = grids[index];
              if (tag.image == "" && tag.tag == "Tất cả") return const SizedBox();
              return GestureDetector(
                onTap: () => Navigator.push(context, checkDeviceRoute(listofFoodByTag(tag.tag))),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(tag.image),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        // ignore: deprecated_member_use
                        AppColors.black.withOpacity(0.5), 
                        BlendMode.dstATop
                      )
                    ),
                  ),
                  child: Text(
                    tag.tag,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              );
            }
          );
        }
      },
    );
  }
}