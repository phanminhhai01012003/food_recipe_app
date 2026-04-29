import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_list.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class CookbookDetail extends StatefulWidget {
  final CookbookModel cookbook;
  const CookbookDetail({super.key, required this.cookbook});

  @override
  State<CookbookDetail> createState() => _CookbookDetailState();
}

class _CookbookDetailState extends State<CookbookDetail> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.secondary,
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.cookbook.cookbookImage,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, progress) => Center(
                        child: CircularProgressIndicator(
                          value: progress.progress, 
                          color: AppColors.yellow
                        )
                      ),
                      width: 100,
                      height: 100,
                      errorWidget: (context, url, error) => Center(
                        child: Icon(
                          Icons.error,
                          size: 20,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cookbook.cookbookName,
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.cookbook.description,
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.normal
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ClampingScrollPhysics(),
                hitTestBehavior: HitTestBehavior.translucent,
                clipBehavior: Clip.hardEdge,
                itemCount: widget.cookbook.foodsList.length,
                itemBuilder: (context, index) => FoodDisplayList(food: widget.cookbook.foodsList[index]),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: MaterialButton(
                      onPressed: () => Navigator.push(context, checkDeviceRoute(editCookbook(widget.cookbook))),
                      color: AppColors.yellow,
                      textColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
                      child: Text("editInformation".tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: MaterialButton(
                      onPressed: () => ShowYesnoDialog.checkDeviceDialog(
                        context, 
                        title: "cookbookDeleteTitle".tr(), 
                        content: "cookbookDeleteDesc".tr(), 
                        onAcceptTap: () => onDelete(widget.cookbook.cookbookId), 
                        onCancelTap: () => Navigator.pop(context)
                      ),
                      color: AppColors.red,
                      textColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
                      child: Text("cookbookDeleteTitle".tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  void onDelete(String id) async{
    context.loaderOverlay.show();
    await Future.delayed(Duration(seconds: 2));
    context.read<CookbookState>().removeCookbook(id);
    context.loaderOverlay.hide();
    Message.showScaffoldMessage(context, "deleteSuccess".tr(), AppColors.green);
    Navigator.pop(context);
    await Future.delayed(Duration(seconds: 2), () => Navigator.pop(context));
  }
}