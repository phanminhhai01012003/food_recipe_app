import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/services/firestore/food_recipe/food_services.dart';
import 'package:food_recipe_app/views/main/home/animation_slider.dart';
import 'package:food_recipe_app/views/main/home/categories_grid_list.dart';
import 'package:food_recipe_app/views/main/home/food_recipe_display.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
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
                  onPressed: (){}, 
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
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hôm nay có gì mới",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Hãy cùng nhau khám phá những món ăn mà bạn yêu thích "
                    "và học cách chế biến chúng",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  SizedBox(height: 20),
                  AnimationSlider(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gần đây nhất",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(context, checkDeviceRoute(listofFoodView)), 
                        child: Text(
                          "Xem tất cả",
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  FoodRecipeDisplay(stream: _foodServices.getFoodByDate(context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dành cho bạn",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(context, checkDeviceRoute(listofFoodView)), 
                        child: Text(
                          "Xem tất cả",
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  FoodRecipeDisplay(stream: _foodServices.getFood(context)),
                  SizedBox(height: 20),
                  Text(
                    "Các thể loại phổ biến",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(height: 10),
                  CategoriesGridList()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}