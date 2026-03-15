import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/save_food_model.dart';
import 'package:food_recipe_app/provider/save_state.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/load_data/no_data.dart';
import 'package:food_recipe_app/widget/other/slider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class SaveFood extends StatefulWidget {
  const SaveFood({super.key});

  @override
  State<SaveFood> createState() => _SaveFoodState();
}

class _SaveFoodState extends State<SaveFood> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
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
        title: Text(
          "saveFood".tr(),
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
            return NoData();
          }
          return ListView.builder(
            padding: EdgeInsets.all(12),
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
                  onPressed: (context) => onDelete(value[index]),
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
  void onDelete(SaveFoodModel model) {
    ShowYesnoDialog.checkDeviceDialog(
      context, 
      title: "deleteSaveTitle".tr(), 
      content: "deleteSaveDesc".tr(), 
      onAcceptTap: () {
        context.loaderOverlay.show();
        context.read<SaveState>().toggleRemove(model);
        context.loaderOverlay.hide();
        Message.showScaffoldMessage(context, "deleteSuccess".tr(), AppColors.green);
        Navigator.pop(context);
      }, 
      onCancelTap: () => Navigator.pop(context)
    );
  }
}