import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/model/food/cookbook_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/views/main/cookbook/widget/cookbook_list_widget.dart';
import 'package:food_recipe_app/widget/load_data/no_data.dart';
import 'package:provider/provider.dart';

class CookbookScreen extends StatefulWidget {
  const CookbookScreen({super.key});

  @override
  State<CookbookScreen> createState() => _CookbookScreenState();
}

class _CookbookScreenState extends State<CookbookScreen> {
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
              size: 20
            )
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        title: Text(
          "myCookbook".tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      body: Selector<CookbookState, List<CookbookModel>>(
        selector: (context, state) => state.bookProducts,
        shouldRebuild: (previous, next) => previous != next,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return NoData();
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(16),
            hitTestBehavior: HitTestBehavior.translucent,
            clipBehavior: Clip.hardEdge,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: value.length,
            itemBuilder: (context, index) => CookbookListWidget(cookbook: value[index])
          );      
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, checkDeviceRoute(addCookbook)),
        shape: CircleBorder(),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        child: Icon(Icons.add, size: 25),
      ),
    );
  }
}