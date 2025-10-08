import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_list.dart';
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
    return Scaffold(
      backgroundColor: AppColors.white,
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
                      progressIndicatorBuilder: (context, url, progress) => Center(
                        child: CircularProgressIndicator(
                          value: progress.progress, 
                          color: AppColors.yellow
                        )
                      ),
                      width: 50,
                      height: 50,
                      errorWidget: (context, url, error) => Image.asset(foodDesignImage),
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    children: [
                      Text(
                        widget.cookbook.cookbookName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.cookbook.description,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.normal
                          ),
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
                clipBehavior: Clip.hardEdge,
                itemCount: widget.cookbook.foodsList.length,
                itemBuilder: (context, index) => FoodDisplayList(food: widget.cookbook.foodsList[index]),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () => Navigator.push(context, checkDeviceRoute(editCookbook(widget.cookbook))),
                    color: AppColors.yellow,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
                    child: Text("Sửa thông tin",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () => ShowYesnoDialog.checkDeviceDialog(
                      context, 
                      title: "Xóa nhật ký", 
                      content: "Bạn có muốn xóa nhật ký vừa tạo không?", 
                      onAcceptTap: () => context.read<CookbookState>().removeCookbook(widget.cookbook.cookbookId), 
                      onCancelTap: () => Navigator.pop(context)
                    ),
                    color: AppColors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
                    child: Text("Xóa nhật ký",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal
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
}