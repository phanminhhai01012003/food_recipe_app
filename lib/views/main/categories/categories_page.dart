import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/category_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/services/firestore/food_recipe/food_services.dart';
import 'package:food_recipe_app/views/main/categories/tag_services.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_grid.dart';
import 'package:intl/intl.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String selectCategory = "Tất cả";
  final _tagServices = TagServices();
  final _foodServices = FoodServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: currentUser!.photoURL!,
                        progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(value: progress.progress),
                        errorWidget: (context, url, error) => Image.asset(userDefaultImage),
                        fit: BoxFit.cover,
                        width: 33,
                        height: 33,
                      ),
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Xin chào! ${currentUser!.displayName}",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          DateFormat("dd/MM/yyyy").format(DateTime.now()),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.push(context, checkDeviceRoute(notification)), 
                  icon: Icon(
                    Icons.notifications,
                    size: 20,
                    color: AppColors.white,
                  )
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              readOnly: true,
              onTap: () => Navigator.push(context, checkDeviceRoute(searchPage)),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(33),
                  borderSide: BorderSide.none
                ),
                prefixIcon: SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(Icons.search, color: AppColors.grey),
                ),
                hintText: "Tìm kiếm",
                hintStyle: TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: AppColors.white,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.white,
                  offset: Offset(5, 5),
                  blurRadius: 5,
                  spreadRadius: 5,
                  blurStyle: BlurStyle.solid
                )
              ]
            ),
            child: Column(
              children: [
                StreamBuilder(
                  stream: _tagServices.getTags(context), 
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.hasError) {
                      return SizedBox.shrink();
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<CategoryModel> categories = snapshot.data!;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            categories.length,
                            (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectCategory = categories[index].tag;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectCategory == categories[index].tag 
                                    ? AppColors.green : AppColors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: selectCategory == categories[index].tag 
                                    ? AppColors.white : AppColors.black)
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10
                                ),
                                margin: EdgeInsets.only(right: 20),
                                child: Text(
                                  categories[index].tag,
                                  style: TextStyle(
                                    color: selectCategory == categories[index].tag
                                      ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14
                                  ),
                                ),
                              ),
                            )
                          ),
                        ),
                      );
                    }
                  }
                ),
                SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder(
                    stream: selectCategory == "Tất cả" 
                      ? _foodServices.getFood(context) 
                      : _foodServices.getFoodByTag(context, selectCategory), 
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.hasError) {
                        return SizedBox.shrink();
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        List<FoodModel> foodList = snapshot.data!;
                        return GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: ClampingScrollPhysics(),
                          hitTestBehavior: HitTestBehavior.translucent,
                          clipBehavior: Clip.hardEdge,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8
                          ),
                          itemCount: foodList.length, 
                          itemBuilder: (context, index) => FoodDisplayGrid(food: foodList[index])
                        );
                      }
                    }
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}