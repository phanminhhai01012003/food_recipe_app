import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/widget/other/load_data.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/slider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MyFood extends StatefulWidget {
  const MyFood({super.key});

  @override
  State<MyFood> createState() => _MyFoodState();
}

class _MyFoodState extends State<MyFood> {
  void onDelete(String id) async{
    context.loaderOverlay.show();
    await foodServices.deleteFood(context, id).then((_){
      context.loaderOverlay.hide();
      Message.showScaffoldMessage(context, "Đã xóa", AppColors.green);
      Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
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
        backgroundColor: theme.appBarTheme.backgroundColor,
        centerTitle: true,
        title: Text(
          "Món ăn của bạn",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: StreamBuilder(
        stream: foodServices.getFoodByUser(context, currentUser.uid), 
        builder: (context, snapshot){
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: Text("Không có dữ liệu",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w800
                ),
              )
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadData(isList: true);
          } else {
            List<FoodModel> foodData = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(12),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              hitTestBehavior: HitTestBehavior.translucent,
              clipBehavior: Clip.hardEdge,
              physics: ClampingScrollPhysics(),
              itemCount: foodData.length,
              itemBuilder: (context, index) => SliderWidget(
                food: foodData[index], 
                children: [
                  SlidableAction(
                    onPressed: (context) => Navigator.push(context, checkDeviceRoute(editFood(foodData[index]))),
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.white,
                    icon: Icons.edit,
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      ShowYesnoDialog.checkDeviceDialog(
                        context, 
                        title: "Xóa món ăn", 
                        content: "Bạn có chắc chắn muốn xóa không? Bạn sẽ không thể khôi phục thành quả của mình sau khi xóa", 
                        onAcceptTap: () => onDelete(foodData[index].foodId), 
                        onCancelTap: () => Navigator.pop(context)
                      );
                    },
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                    icon: Icons.delete,
                  )
                ], 
              )
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, checkDeviceRoute(addFood)),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        shape: CircleBorder(),
        child: Icon(Icons.add, size: 25),
      ),
    );
  }
}