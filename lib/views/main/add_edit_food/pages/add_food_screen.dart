import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/list_constants.dart';
import 'package:food_recipe_app/common/extension/duration_extension.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/utils/convert.dart';
import 'package:food_recipe_app/model/food/food_model.dart';
import 'package:food_recipe_app/views/main/add_edit_food/widget/file_chosen_widget.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_time_picker.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_image_picker.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/toggle_switch.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:video_player/video_player.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  VideoPlayerController? _playerController;
  File? file;
  String fileUrl = "";
  String? selectCategory;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dietController = TextEditingController();
  Duration _duration = Duration.zero;
  List<TextEditingController> ingredientController = [TextEditingController()];
  List<TextEditingController> stepController = [TextEditingController()];
  bool isAI = false;
  void invalidInformation(){
    if (titleController.text.isEmpty) {
      Message.showToast("foodTitleRequired".tr());
      context.loaderOverlay.hide();
      return;
    }
    if (selectCategory == null && selectCategory!.isEmpty){
      Message.showToast("categoriesInvalid".tr());
      context.loaderOverlay.hide();
      return;
    }
    if (ingredientController.any((e) => e.text.isEmpty) || stepController.any((e) => e.text.isEmpty)){
      Message.showToast("ingredientsOrStepsInvalid".tr());
      context.loaderOverlay.hide();
      return;
    }
    if (int.parse(dietController.text) <= 0 || _duration.ddhhmmss == "00:00:00:00"){
      Message.showToast("dietOrDurationInvalid".tr());
      context.loaderOverlay.hide();
      return;
    }
  }
  void onAddFood() async{
    context.loaderOverlay.show();
    await Future.delayed(Duration(seconds: 2));
    invalidInformation();
    if (file != null) {
      fileUrl = await imageServices.uploadImage(context, file!, foodFolder);
    }
    FoodModel food = FoodModel(
      foodId: generateRandomString(25), 
      image: file == null && fileUrl.isEmpty ? foodDefaultImage : fileUrl, 
      title: titleController.text, 
      description: descriptionController.text, 
      userId: currentUser.uid, 
      userName: currentUser.displayName ?? "", 
      avatar: currentUser.photoURL ?? "", 
      tag: selectCategory!, 
      diet: int.parse(dietController.text), 
      duration: _duration.ddhhmmss, 
      ingredients: ingredientController.map((e) => e.text).toList(), 
      steps: stepController.map((e) => e.text).toList(),
      isAI: isAI,
      views: 0,
      createdAt: DateTime.now(), 
      likes: [],
    );
    await foodServices.addFood(context, food);
    if (!mounted) return;
    context.loaderOverlay.hide();
    Message.showScaffoldMessage(context, "addFoodSuccess".tr(), AppColors.green);
    Navigator.pop(context);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    descriptionController.dispose();
    dietController.dispose();
    ingredientController.forEach((controller) => controller.dispose());
    stepController.forEach((controller) => controller.dispose());
    if (_playerController != null) {
      _playerController!.pause();
      _playerController!.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              ShowYesnoDialog.checkDeviceDialog(
                context, 
                title: "discardChangeTitle".tr(), 
                content: "discardChangeDesc".tr(), 
                onAcceptTap: () async{
                  Navigator.pop(context);
                  await Future.delayed(Duration(seconds: 1),(){
                    Navigator.pop(context);
                  });
                }, 
                onCancelTap: () => Navigator.pop(context)
              );
            }, 
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, 
              size: 20
            )
          ),
        ),
        title: Text("addFood".tr()),
        actions: [
          IconButton(
            onPressed: onAddFood, 
            icon: Icon(Icons.check_circle, size: 20)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, checkDeviceRoute(AIpage)),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        shape: CircleBorder(),
        child: Icon(Icons.auto_awesome, size: 25),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: FileChosenWidget(
                controller: _playerController,
                file: file, 
                fileUrl: fileUrl, 
                onTap: () async {
                  final filePicked = await showImagePickerModal(context, true);
                  if (filePicked != null){
                    bool isImagePicked = filePicked.toString().contains("jpg") || filePicked.toString().contains("jpeg") || filePicked.toString().contains("png");
                    if (isImagePicked) {
                      setState(() {
                        file = filePicked;
                        _playerController = null;
                      });
                    } else {
                      _playerController = VideoPlayerController.file(filePicked)..initialize().then((_){
                        setState(() {
                          file = filePicked;
                          _playerController!.play();
                          _playerController!.setLooping(true);
                        });
                      });
                    }
                  }
                },                
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ảnh/Video do AI tạo ra",
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900
                  ),
                ),
                ToggleSwitch.toggleDependsOnDevice(
                  isAI, 
                  (value) {
                    setState(() {
                      isAI = value;
                    });
                  }
                )
              ],
            ),
            SizedBox(height: 20),
            Text("foodTitle".tr(),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: titleController,
              cursorColor: AppColors.blue,
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
                hintText: "foodTitleInput".tr(),
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
              controller: descriptionController,
              cursorColor: AppColors.blue,
              maxLength: 1000,
              maxLines: 5,
              minLines: 5,
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
                hintText: "foodDescInput".tr(),
                hintStyle: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800
                ),
                counterText: ""
              ),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w800,
                fontSize: 14
              ),
            ),
            SizedBox(height: 20),
            Text("categories".tr(),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.secondary)
              ),
              child: DropdownButton(
                underline: SizedBox(),
                isExpanded: true,
                hint: Text("select".tr(),
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.normal
                  ),
                ),
                items: categoryList.map((String item){
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item.tr(),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value){
                  setState(() {
                    selectCategory = value;
                  });
                },
                value: selectCategory,
                icon: Icon(Icons.keyboard_arrow_down),
                iconSize: 20,
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("diet".tr(),
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 33,
                      width: 70,
                      child: TextField(
                        controller: dietController,
                        textAlign: TextAlign.center,
                        cursorColor: AppColors.blue,
                        keyboardType: TextInputType.numberWithOptions(decimal: false),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.green)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.colorScheme.secondary)
                          ),
                        ),
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w800,
                          fontSize: 14
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text("people".tr(),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("duration".tr(),
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900
                  ),
                ),
                GestureDetector(
                  onTap: () async{
                    final duration = await showTimePickerModal(context, null);
                    if (duration != null) {
                      setState(() {
                        _duration = duration;
                      });
                    }
                  },
                  child: Container(
                    width: 120,
                    height: 33,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.primary,
                      border: Border.all(color: theme.colorScheme.secondary)
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _duration.ddhhmmss,
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Text("ingredients".tr(),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 10),
            ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 5),
              itemCount: ingredientController.length,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return TextField(
                  controller: ingredientController[index],
                  cursorColor: AppColors.blue,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14
                  ),
                  decoration: InputDecoration(
                    hintText: "ingredientsInput".tr(),
                    hintStyle: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.green)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.secondary)
                    ),
                    prefixIcon: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w800,
                          fontSize: 14
                        ),
                      ),
                    ),
                    suffixIcon: Visibility(
                      visible: index != 0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            ingredientController[index].clear();
                            ingredientController[index].dispose();
                            ingredientController.removeAt(index);
                          });
                        }, 
                        icon: Icon(
                          Icons.delete, 
                          size: 30, 
                          color: AppColors.red
                        )
                      )
                    ),
                  ),
                );
              }
            ),
            SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () {
                    setState(() {
                      ingredientController.add(TextEditingController());
                    });
                  }, 
                  child: Text("addManual".tr(),
                    style: TextStyle(fontSize: 16),
                  )
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () {
                    
                  }, 
                  child: Text("addFromFridge".tr(),
                    style: TextStyle(fontSize: 16),
                  )
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("steps1".tr(),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 10),
            ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 5),
              itemCount: stepController.length,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return TextField(
                  controller: stepController[index],
                  cursorColor: AppColors.blue,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14
                  ),
                  decoration: InputDecoration(
                    hintText: "stepsInput".tr(),
                    hintStyle: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.green)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.secondary)
                    ),
                    prefixIcon: Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w800,
                          fontSize: 14
                        ),
                      ),
                    ),
                    suffixIcon: Visibility(
                      visible: index != 0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            stepController[index].clear();
                            stepController[index].dispose();
                            stepController.removeAt(index);
                          });
                        }, 
                        icon: Icon(
                          Icons.delete, 
                          size: 30, 
                          color: AppColors.red
                        )
                      )
                    ),
                  ),
                );
              }
            ),
            SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () {
                    setState(() {
                      stepController.add(TextEditingController());
                    });
                  }, 
                  child: Text("add".tr(),
                    style: TextStyle(fontSize: 16),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}