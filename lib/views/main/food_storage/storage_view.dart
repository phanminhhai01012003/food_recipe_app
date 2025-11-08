import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/model/recent_view_model.dart';
import 'package:food_recipe_app/model/save_food_model.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/provider/history_state.dart';
import 'package:food_recipe_app/provider/save_state.dart';
import 'package:food_recipe_app/views/main/cookbook/widget/cookbook_widget.dart';
import 'package:food_recipe_app/views/main/settings/user_widget.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_grid.dart';
import 'package:provider/provider.dart';

class StorageView extends StatefulWidget {
  const StorageView({super.key});

  @override
  State<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              FutureBuilder(
                future: userServices.getUserById(context, currentUser.uid), 
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return SizedBox();
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    List<UserModel> users = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) => UserWidget(
                        user: users[index], 
                        onTap: () => Navigator.push(context, checkDeviceRoute(userInform(users[index])))
                      )
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Món ăn của bạn",
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context, checkDeviceRoute(myFoodScreen)), 
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
              StreamBuilder(
                stream: foodServices.getFoodByUser(context, currentUser.uid), 
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return SizedBox();
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    List<FoodModel> data = snapshot.data!;
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: EdgeInsets.all(12),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: (data.length / 2).toInt(),
                        itemBuilder: (context, index) => FoodDisplayGrid(food: data[index])
                      ),
                    );
                  }
                }
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Món ăn đã lưu",
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context, checkDeviceRoute(saveFoodScreen)), 
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
              Selector<SaveState, List<SaveFoodModel>>(
                selector: (context, state) => state.foodProducts,
                shouldRebuild: (previous, next) => true,
                builder: (context, value, child) {
                  if (value.isEmpty) {
                    return SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: EdgeInsets.all(12),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: (value.length / 2).toInt(),
                      itemBuilder: (context, index) => FoodDisplayGrid(food: value[index].foods)
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Đã xem gần đây",
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context, checkDeviceRoute(recentScreen)), 
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
              Selector<HistoryState, List<RecentViewModel>>(
                selector: (context, state) => state.viewProducts,
                shouldRebuild: (previous, next) => true,
                builder: (context, value, child) {
                  if (value.isEmpty) {
                    return SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: EdgeInsets.all(12),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: (value.length / 2).toInt(),
                      itemBuilder: (context, index) => FoodDisplayGrid(food: value[index].foods)
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sổ tay nấu ăn",
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context, checkDeviceRoute(recentScreen)), 
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
              Selector<CookbookState, List<CookbookModel>>(
                selector: (context, state) => state.bookProducts,
                shouldRebuild: (previous, next) => true,
                builder: (context, value, child) {
                  if (value.isEmpty) {
                    return SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: EdgeInsets.all(12),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      hitTestBehavior: HitTestBehavior.translucent,
                      clipBehavior: Clip.hardEdge,
                      physics: ClampingScrollPhysics(),
                      itemCount: (value.length / 2).toInt(),
                      itemBuilder: (context, index) => CookbookWidget(book: value[index])
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}