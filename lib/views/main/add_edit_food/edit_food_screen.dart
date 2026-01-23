import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/constants/list_constants.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/convert.dart';
import 'package:food_recipe_app/common/configure/extension.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_time_picker.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_image_picker.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';

class EditFoodScreen extends StatefulWidget {
  final FoodModel food;
  const EditFoodScreen({super.key, required this.food});

  @override
  State<EditFoodScreen> createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  File? image;
  String imageURL = "";
  String? selectCategory;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dietController = TextEditingController();
  Duration _duration = Duration.zero;
  List<TextEditingController> ingredientController = [TextEditingController()];
  List<TextEditingController> stepController = [TextEditingController()];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageURL = widget.food.image;
    titleController.text = widget.food.title;
    descriptionController.text = widget.food.description;
    selectCategory = widget.food.tag;
    dietController.text = widget.food.diet.toString();
    _duration = convertStrToDur(widget.food.duration);
    ingredientController = widget.food.ingredients.map((e) => TextEditingController(text: e)).toList();
    stepController = widget.food.steps.map((e) => TextEditingController(text: e)).toList();
  }
  void invalidInformation(){
    if (titleController.text.isEmpty) {
      Message.showToast("Tên món ăn là bắt buộc");
      context.loaderOverlay.hide();
      return;
    }
    if (selectCategory == null && selectCategory!.isEmpty){
      Message.showToast("Vui lòng chọn thể loại");
      context.loaderOverlay.hide();
      return;
    }
    if (ingredientController.any((e) => e.text.isEmpty) || stepController.any((e) => e.text.isEmpty)){
      Message.showToast("Nguyên liệu hoặc cách làm không được để trống");
      context.loaderOverlay.hide();
      return;
    }
    if (int.parse(dietController.text) <= 0 || _duration.ddhhmmss == "00:00:00:00"){
      Message.showToast("Khẩu phần ăn uống hoặc thời gian thực hiện không hợp lệ");
      context.loaderOverlay.hide();
      return;
    }
  }
  void onUpdateFood() async{
    context.loaderOverlay.show();
    invalidInformation();
    if (image != null) {
      imageURL = await imageServices.uploadImage(context, image!, foodFolder);
    }
    FoodModel food = FoodModel(
      foodId: widget.food.foodId, 
      image: image == null && imageURL.isEmpty ? foodDefaultImage : imageURL, 
      title: titleController.text, 
      description: descriptionController.text, 
      userId: widget.food.userId, 
      userName: widget.food.userName, 
      avatar: widget.food.avatar, 
      tag: selectCategory!, 
      diet: int.parse(dietController.text), 
      duration: _duration.ddhhmmss, 
      ingredients: ingredientController.map((e) => e.text).toList(), 
      steps: stepController.map((e) => e.text).toList(), 
      views: widget.food.views,
      createdAt: widget.food.createdAt, 
      likes: widget.food.likes
    );
    await foodServices.updateFood(context, food);
    if(!mounted) return;
    context.loaderOverlay.hide();
    Message.showScaffoldMessage(context, "Cập nhật thành công", AppColors.green);
    Navigator.pop(context);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    dietController.dispose();
    ingredientController.forEach((controller) => controller.dispose());
    stepController.forEach((controller) => controller.dispose());
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
        title: Text("Chỉnh sửa món ăn"),
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              ShowYesnoDialog.checkDeviceDialog(
                context, 
                title: "Loại bỏ thay đổi", 
                content: "Bạn có chắc chắn muốn bỏ thay đổi không? Mọi thay đổi sẽ không được lưu", 
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
        actions: [
          IconButton(
            onPressed: onUpdateFood, 
            icon: Icon(Icons.check_circle, size: 30)
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            image != null ? InkWell(
              onTap: () => showImagePickerModal(context),
              child: Image.file(
                image!,
                errorBuilder: (context, error, stackTrace) => Image.network(foodDefaultImage),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ) : InkWell(
              onTap: () => showImagePickerModal(context),
              child: Image.network(
                imageURL,
                errorBuilder: (context, error, stackTrace) => Image.network(foodDefaultImage),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text("Tên món ăn",
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.secondary)
                ),
                hintText: "Nhập tên món ăn",
                hintStyle: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Mô tả",
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.secondary)
                ),
                hintText: "Mô tả về món ăn đó",
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
            Text("Thể loại",
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
                hint: Text("Chọn",
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.normal
                  ),
                ),
                items: categoryList.map((String item){
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item,
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
                Text("Khẩu phần",
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
                        cursorColor: AppColors.blue,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.numberWithOptions(decimal: false),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.green)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.colorScheme.secondary)
                          ),
                          hintText: "Số lượng",
                          hintStyle: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800
                          )
                        ),
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w800,
                          fontSize: 14
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text("người",
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
                Text("Thời gian",
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900
                  ),
                ),
                GestureDetector(
                  onTap: () async{
                    final duration = await showTimePickerModal(context, _duration);
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
            Text("Các nguyên liệu chính",
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
                    hintText: "Nguyên liệu",
                    hintStyle: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.green)
                    ),
                    border: OutlineInputBorder(
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
                  child: Text("Thêm",
                    style: TextStyle(fontSize: 16),
                  )
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Cách làm",
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
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14
                  ),
                  cursorColor: AppColors.blue,
                  decoration: InputDecoration(
                    hintText: "Các bước chế biến",
                    hintStyle: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.green)
                    ),
                    border: OutlineInputBorder(
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
                  child: Text("Thêm",
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