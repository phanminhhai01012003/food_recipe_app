import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/views/main/cookbook/widget/cookbook_widget.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_grid.dart';
import 'package:provider/provider.dart';

class PersonalScreen extends StatefulWidget {
  final String id;
  const PersonalScreen({super.key, required this.id});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> with TickerProviderStateMixin{
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2, 
      vsync: this
    );
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        title: Text("personalPage".tr(),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              size: 20,
            )
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: userServices.getUserById(context, widget.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.hasError) {
                  return SizedBox();
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: AppColors.yellow));
                } else{
                  List<UserModel> userData = snapshot.data!;
                  return ListView.builder(
                    itemCount: userData.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => userInfo(user: userData[index])
                  );
                }
              },
            ),
            TabBar(
              controller: _tabController,
              unselectedLabelColor: theme.colorScheme.secondary,
              labelColor: AppColors.green,
              dividerColor: theme.colorScheme.secondary,
              indicatorColor: AppColors.green,
              padding: EdgeInsets.all(12),
              tabs: [
                Text(
                  "foodRecipe".tr(),
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "cookbook".tr(),
                  style: TextStyle(fontSize: 14),
                )
              ]
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  StreamBuilder(
                    stream: foodServices.getFoodByUser(context, widget.id), 
                    builder: (context, snapshot){
                      if (!snapshot.hasData || snapshot.hasError) {
                        return Center(child: Icon(Icons.error, size: 100, color: AppColors.red));
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: AppColors.yellow));
                      } else {
                        List<FoodModel> foodData = snapshot.data!;
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8
                          ),
                          scrollDirection: Axis.vertical,
                          itemCount: foodData.length,
                          shrinkWrap: true,
                          hitTestBehavior: HitTestBehavior.translucent,
                          clipBehavior: Clip.hardEdge,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) => FoodDisplayGrid(food: foodData[index])
                        );
                      }
                    }
                  ),
                  Consumer<CookbookState>(
                    builder: (context, value, child) {
                      return FutureBuilder(
                        future: value.getDataFromId(widget.id), 
                        builder: (context, snapshot){
                          if (!snapshot.hasData || snapshot.hasError) {
                            return Center(child: Icon(Icons.error, size: 100, color: AppColors.red));
                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator(color: AppColors.yellow));
                          } else {
                            List<CookbookModel> cookbookData = snapshot.data!;
                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 3
                              ),
                              scrollDirection: Axis.vertical,
                              itemCount: cookbookData.length,
                              shrinkWrap: true,
                              hitTestBehavior: HitTestBehavior.translucent,
                              clipBehavior: Clip.hardEdge,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) => CookbookWidget(book: cookbookData[index])
                            );
                          }
                        }
                      );
                    },
                  )
                ] 
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget userInfo({required UserModel user}){
    return ListTile(
      tileColor: AppColors.green,
      textColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          imageUrl: user.avatar,
          progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator(value: progress.progress, color: AppColors.yellow)),
          width: 50,
          height: 50,
          errorWidget: (context, url, error) => Center(
            child: Icon(
              Icons.error,
              size: 20,
              color: AppColors.grey,
            ),
          ),
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        user.userName,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800
        ),
      ),
      subtitle: Expanded(
        child: Text(
          user.description,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      onTap: () => Navigator.push(context, checkDeviceRoute(userInform(user))),
    );
  }
}