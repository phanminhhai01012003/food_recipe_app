import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/personal/recent_view_model.dart';
import 'package:food_recipe_app/provider/history_state.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/load_data/no_data.dart';
import 'package:food_recipe_app/widget/other/slider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class RecentView extends StatefulWidget {
  const RecentView({super.key});

  @override
  State<RecentView> createState() => _RecentViewState();
}

class _RecentViewState extends State<RecentView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
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
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        title: Text(
          "recentFood".tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Selector<HistoryState, List<RecentViewModel>>(
        selector: (context, state) => state.viewProducts,
        shouldRebuild: (previous, next) => previous != next,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return NoData();
          }
          return ListView.builder(
            padding: EdgeInsets.all(12),
            shrinkWrap: true,
            hitTestBehavior: HitTestBehavior.translucent,
            clipBehavior: Clip.hardEdge,
            scrollDirection: Axis.vertical,
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
  void onDelete(RecentViewModel model) {
    ShowYesnoDialog.checkDeviceDialog(
      context, 
      title: "deleteRecentTitle".tr(), 
      content: "deleteRecentDesc".tr(), 
      onAcceptTap: () async{
        context.loaderOverlay.show();
        await Future.delayed(Duration(seconds: 2));
        context.read<HistoryState>().toggleRemove(model);
        context.loaderOverlay.hide();
        Message.showScaffoldMessage(context, "deleteSuccess".tr(), AppColors.green);
        Navigator.pop(context);
      }, 
      onCancelTap: () => Navigator.pop(context)
    );
  }
}