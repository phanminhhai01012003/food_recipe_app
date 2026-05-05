import 'dart:collection';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/food/cookbook_model.dart';
import 'package:food_recipe_app/model/food/food_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/views/main/add_edit_food/widget/edit_file_chosen.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_image_picker.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/load_data/load_data.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class EditCookbookPage extends StatefulWidget {
  final CookbookModel cookbook;
  const EditCookbookPage({super.key, required this.cookbook});

  @override
  State<EditCookbookPage> createState() => _EditCookbookPageState();
}

class _EditCookbookPageState extends State<EditCookbookPage> {
  File? file;
  String fileUrl = "";
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  HashSet<FoodModel> choices = HashSet();
  void invalidInformation() {
    if (_titleController.text.isEmpty){
      Message.showToast("cookbookTitleRequired".tr());
      context.loaderOverlay.hide();
      return;
    }
    if (choices.isEmpty) {
      Message.showToast("cookbookFoodRequired".tr());
      context.loaderOverlay.hide();
      return;
    }
  }
  void onMultiSelect(FoodModel food){
    if (choices.contains(food)){
      choices.remove(food);
    } else{
      choices.add(food);
    }
    setState(() {});
  }
  void update() async{
    context.loaderOverlay.show();
    await Future.delayed(Duration(seconds: 2));
    invalidInformation();
    if (file != null) {
      fileUrl = await imageServices.uploadImage(context, file!, cookbookFolder);
    }
    CookbookModel cookbook = CookbookModel(
      cookbookId: widget.cookbook.cookbookId, 
      cookbookImage: file == null && fileUrl.isEmpty ? foodDesignImage : fileUrl, 
      cookbookName: _titleController.text, 
      description: _descriptionController.text, 
      userId: widget.cookbook.userId, 
      createdAt: widget.cookbook.createdAt, 
      foodsList: choices.toList()
    );
    context.read<CookbookState>().updateCookbook(cookbook);
    if (!mounted) return;
    context.loaderOverlay.hide();
    Message.showScaffoldMessage(context, "updateFoodSuccess".tr(), AppColors.green);
    Navigator.pop(context);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fileUrl = widget.cookbook.cookbookImage;
    _titleController.text = widget.cookbook.cookbookName;
    _descriptionController.text = widget.cookbook.description;
    choices = HashSet<FoodModel>.from(widget.cookbook.foodsList);
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          choices.isNotEmpty ? "selectedFood".tr(choices.length.toString()) : "updateCookbook".tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: choices.isNotEmpty ? IconButton(
            onPressed: (){
              choices.clear();
              setState(() {});
            }, 
            icon: Icon(Icons.close, size: 20)
          ) : IconButton(
            onPressed: () => ShowYesnoDialog.checkDeviceDialog(
              context, 
              title: "discardChangeTitle".tr(), 
              content: "discardChangeDesc".tr(), 
              onAcceptTap: () async{
                Navigator.pop(context);
                await Future.delayed(Duration(seconds: 1), (){
                  Navigator.pop(context);
                });
              }, 
              onCancelTap: () => Navigator.pop(context)
            ),
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, 
              size: 20
            )
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, checkDeviceRoute(AIpage)),
        shape: CircleBorder(),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        child: Icon(Icons.auto_awesome, size: 25),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: EditFileChosen(
                file: file, 
                fileUrl: fileUrl, 
                onTap: () async {
                  final filePicked = await showImagePickerModal(context, false);
                  if (filePicked != null) {
                    file = filePicked;
                  } 
                }
              ),
            ),
            SizedBox(height: 20),
            Text(
              "cookbookName".tr(),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _titleController,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w800,
                fontSize: 14
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.green)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.secondary)
                ),
                hintText: "cookbookNameInput".tr(),
                hintStyle: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("foodDesc".tr(),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _descriptionController,
              maxLength: 1000,
              maxLines: 3,
              minLines: 3,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.green)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.secondary)
                ),
                hintText: "cookbookDescInput".tr(),
                hintStyle: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800
                ),
                counterText: ""
              ),
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w800,
                fontSize: 14
              ),
            ),
            SizedBox(height: 20),
            StreamBuilder(
              stream: foodServices.getFood(context), 
              builder: (context, snapshot){
                if (!snapshot.hasData || snapshot.hasError){
                  return SizedBox.shrink();
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadData(isList: true);
                } else {
                  List<FoodModel> foodData = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: foodData.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => onMultiSelect(foodData[index]),
                      child: Card(
                        elevation: 10,
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: choices.contains(foodData[index]) ? AppColors.green : theme.colorScheme.primary,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: foodData[index].image,
                                progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator(value: progress.progress)),
                                width: 30,
                                height: 30,
                                errorWidget: (context, url, error) => Image.asset(foodDesignImage),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                foodData[index].title,
                                style: TextStyle(
                                  color: choices.contains(foodData[index]) ? AppColors.white : theme.colorScheme.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                ),
                onPressed: update, 
                child: Text(
                  "update".tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),
                )
              ),
            )
          ],
        ),
      )
    );
  }
}