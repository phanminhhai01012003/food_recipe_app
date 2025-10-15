import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/save_food_model.dart';
import 'package:food_recipe_app/provider/save_state.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/other/slider.dart';
import 'package:provider/provider.dart';

class SaveFood extends StatefulWidget {
  const SaveFood({super.key});

  @override
  State<SaveFood> createState() => _SaveFoodState();
}

class _SaveFoodState extends State<SaveFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        title: Text(
          "Đã lưu",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Selector<SaveState, List<SaveFoodModel>>(
        selector: (context, state) => state.foodProducts,
        shouldRebuild: (previous, next) => true,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error, 
                    size: 50, 
                    color: AppColors.red
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Không có dữ liệu",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal
                    ),
                  )
                ],
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            hitTestBehavior: HitTestBehavior.translucent,
            clipBehavior: Clip.hardEdge,
            physics: ClampingScrollPhysics(),
            itemCount: value.length,
            itemBuilder: (context, index) => SliderWidget(
              food: value[index].foods, 
              children: [
                SlidableAction(
                  onPressed: (context) => onDelete(context, value[index]),
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
                  icon: Icons.delete,
                )
              ]
            )
          );
        },
      ),
    );
  }
  void onDelete(BuildContext context, SaveFoodModel model) {
    ShowYesnoDialog.checkDeviceDialog(
      context, 
      title: "Xóa món ăn đã lưu", 
      content: "Bạn có chắc chắn muốn xóa món ăn đã lưu không?", 
      onAcceptTap: () {
        context.read<SaveState>().toggle(model);
        Message.showScaffoldMessage(context, "Đã xóa", AppColors.green);
        Navigator.pop(context);
      }, 
      onCancelTap: () => Navigator.pop(context)
    );
  }
}