import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/data/enum.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/model/ingredient_model.dart';
import 'package:food_recipe_app/model/recent_view_model.dart';
import 'package:food_recipe_app/model/save_food_model.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/provider/fridge_state.dart';
import 'package:food_recipe_app/provider/history_state.dart';
import 'package:food_recipe_app/provider/save_state.dart';
import 'package:food_recipe_app/views/main/cookbook/widget/cookbook_widget.dart';
import 'package:food_recipe_app/views/main/refrigerator/widgets/product_grid.dart';
import 'package:food_recipe_app/views/main/settings/user_widget.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_grid.dart';
import 'package:provider/provider.dart';

class StorageView extends StatefulWidget {
  const StorageView({super.key});

  @override
  State<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  void onNavigation(StorageMode mode){
    switch(mode){
      case StorageMode.myFood:
        Navigator.push(context, checkDeviceRoute(myFoodScreen));
        break;
      case StorageMode.saveFood:
        Navigator.push(context, checkDeviceRoute(saveFoodScreen));
        break;
      case StorageMode.recentView:
        Navigator.push(context, checkDeviceRoute(recentScreen));
        break;
      case StorageMode.cookbook:
        Navigator.push(context, checkDeviceRoute(cookbookPage));
        break;
      case StorageMode.fridge:
        Navigator.push(context, checkDeviceRoute(smartFridgeView));
        break;
    }
  }
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
                    "myFood".tr(),
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigation(StorageMode.myFood), 
                    child: Text(
                      "viewAll".tr(),
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
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: StreamBuilder(
                  stream: foodServices.getFoodByUser(context, currentUser.uid), 
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.hasError) {
                      return SizedBox();
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<FoodModel> data = snapshot.data!;
                      return SizedBox(
                        height: 222,
                        child: ListView.builder(
                          padding: EdgeInsets.all(12),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: data.length ~/ 2,
                          itemBuilder: (context, index) => FoodDisplayGrid(food: data[index])
                        ),
                      );
                    }
                  }
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "saveFood".tr(),
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigation(StorageMode.saveFood), 
                    child: Text(
                      "viewAll".tr(),
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
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Selector<SaveState, List<SaveFoodModel>>(
                  selector: (context, state) => state.foodProducts,
                  shouldRebuild: (previous, next) => previous != next,
                  builder: (context, value, child) {
                    if (value.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return SizedBox(
                      height: 222,
                      child: ListView.builder(
                        padding: EdgeInsets.all(12),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: value.length ~/ 2,
                        itemBuilder: (context, index) => FoodDisplayGrid(food: value[index].foods)
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "recentFood".tr(),
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigation(StorageMode.recentView), 
                    child: Text(
                      "viewAll".tr(),
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
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Selector<HistoryState, List<RecentViewModel>>(
                  selector: (context, state) => state.viewProducts,
                  shouldRebuild: (previous, next) => previous != next,
                  builder: (context, value, child) {
                    if (value.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return SizedBox(
                      height: 222,
                      child: ListView.builder(
                        padding: EdgeInsets.all(12),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: value.length ~/ 2,
                        itemBuilder: (context, index) => FoodDisplayGrid(food: value[index].foods)
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "myCookbook".tr(),
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigation(StorageMode.cookbook), 
                    child: Text(
                      "viewAll".tr(),
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
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Selector<CookbookState, List<CookbookModel>>(
                  selector: (context, state) => state.bookProducts,
                  shouldRebuild: (previous, next) => previous != next,
                  builder: (context, value, child) {
                    if (value.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return SizedBox(
                      height: 222,
                      child: ListView.builder(
                        padding: EdgeInsets.all(12),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        hitTestBehavior: HitTestBehavior.translucent,
                        clipBehavior: Clip.hardEdge,
                        physics: ClampingScrollPhysics(),
                        itemCount: value.length ~/ 2,
                        itemBuilder: (context, index) => CookbookWidget(book: value[index])
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "smartFridge".tr(),
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigation(StorageMode.fridge), 
                    child: Text(
                      "viewAll".tr(),
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
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Selector<FridgeState, List<IngredientModel>>(
                  selector: (context, state) => state.fridge,
                  shouldRebuild: (previous, next) => previous != next,
                  builder: (context, value, child) {
                    if (value.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return SizedBox(
                      height: 222,
                      child: ListView.builder(
                        padding: EdgeInsets.all(12),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: value.length ~/ 2,
                        itemBuilder: (context, index) => ProductGrid(ingredient: value[index])
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}