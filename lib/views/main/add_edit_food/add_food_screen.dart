import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/convert.dart';
import 'package:food_recipe_app/common/extension.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_time_picker.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_image_picker.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  File? image;
  String? imageURL;
  String? selectCategory;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dietController = TextEditingController();
  String _duration = Duration.zero.toString();
  List<TextEditingController> ingredientController = [TextEditingController()];
  List<TextEditingController> stepController = [TextEditingController()];
  void onAddFood() async{
    context.loaderOverlay.show();
    if (titleController.text.isEmpty) {
      Message.showToast("Tên món ăn là bắt buộc");
      context.loaderOverlay.hide();
      return;
    }
    imageURL = await imageServices.uploadImage(context, image!, foodFolder);
    FoodModel food = FoodModel(
      foodId: generateRandomString(20), 
      image: image == null && imageURL!.isEmpty ? foodDesignImage : imageURL!, 
      title: titleController.text, 
      description: descriptionController.text, 
      userId: currentUser.uid, 
      userName: currentUser.displayName!, 
      avatar: currentUser.photoURL!, 
      tag: selectCategory!, 
      diet: int.parse(dietController.text), 
      duration: _duration.ddhhmmss, 
      ingredients: ingredientController.map((e) => e.text).toList(), 
      steps: stepController.map((e) => e.text).toList(), 
      createdAt: DateTime.now(), 
      likes: [],
    );
    await foodServices.addFood(context, food);
    if (!mounted) return;
    context.loaderOverlay.hide();
    Message.showScaffoldMessage(context, "Đã tải thành công", AppColors.green);
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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        centerTitle: true,
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
        title: Text("Thêm món mới"),
        actions: [
          IconButton(
            onPressed: onAddFood, 
            icon: Icon(Icons.check_circle, size: 20)
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: image == null && imageURL!.isEmpty
              ? InkWell(
                onTap: () => showImagePickerModal(context, image!),
                child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.black)
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                ),
              )
              : image != null ? InkWell(
                onTap: () => showImagePickerModal(context, image!),
                child: ClipRRect(
                  child: Image.file(image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ) : InkWell(
                onTap: () => showImagePickerModal(context, image!),
                child: ClipRRect(
                  child: Image.network(imageURL!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Tên món ăn",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: titleController,
              style: TextStyle(
                color: AppColors.black,
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
                  borderSide: BorderSide(color: AppColors.black)
                ),
                hintText: "Nhập tên món ăn",
                hintStyle: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w800
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Mô tả",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: descriptionController,
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
                  borderSide: BorderSide(color: AppColors.black)
                ),
                hintText: "Mô tả về món ăn đó",
                hintStyle: TextStyle(
                  color: AppColors.black,
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
            Text("Thể loại",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.black)
              ),
              child: DropdownButton(
                underline: SizedBox(),
                isExpanded: true,
                hint: Text("Chọn"),
                items: categoryList.map((String item){
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
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
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Khẩu phần",
                  style: TextStyle(
                    color: AppColors.black,
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
                        keyboardType: TextInputType.numberWithOptions(decimal: false),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.green)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.black)
                          ),
                        ),
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 14
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text("người",
                      style: TextStyle(
                        color: AppColors.black,
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
                    color: AppColors.black,
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
                      color: AppColors.white,
                      border: Border.all(color: AppColors.black)
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _duration.ddhhmmss,
                      style: TextStyle(
                        color: AppColors.black,
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
                color: AppColors.black,
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
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 14
                  ),
                  decoration: InputDecoration(
                    hintText: "Nguyên liệu",
                    hintStyle: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w800
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.green)
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.black)
                    ),
                    prefixIcon: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: AppColors.black,
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
                        icon: Icon(Icons.delete, size: 30, color: AppColors.red)
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
                color: AppColors.black,
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
                    color: AppColors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 14
                  ),
                  decoration: InputDecoration(
                    hintText: "Các bước chế biến",
                    hintStyle: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w800
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.green)
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.black)
                    ),
                    prefixIcon: Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: AppColors.black,
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
                        icon: Icon(Icons.delete, size: 30, color: AppColors.red)
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