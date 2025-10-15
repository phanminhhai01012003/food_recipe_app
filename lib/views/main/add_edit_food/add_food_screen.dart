import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/convert.dart';
import 'package:food_recipe_app/common/extension.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/services/firestore/food_recipe/food_services.dart';
import 'package:food_recipe_app/services/image/image_service.dart';
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
  final _currentUser = FirebaseAuth.instance.currentUser!;
  final _foodServices = FoodServices();
  final _imageServices = ImageService();
  File? image;
  String? imageURL;
  String? selectCategory;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dietController = TextEditingController();
  late String _duration = Duration.zero.toString();
  List<TextEditingController> ingredientController = [TextEditingController()];
  List<TextEditingController> stepController = [TextEditingController()];
  void onAddFood() async{
    context.loaderOverlay.show();
    if (titleController.text.isEmpty) {
      Message.showToast("Tên món ăn là bắt buộc");
      context.loaderOverlay.hide();
      return;
    }
    imageURL = await _imageServices.uploadImage(context, image!, foodFolder);
    FoodModel food = FoodModel(
      foodId: generateRandomString(20), 
      image: imageURL!, 
      title: titleController.text, 
      description: descriptionController.text, 
      userId: _currentUser.uid, 
      userName: _currentUser.displayName!, 
      avatar: _currentUser.photoURL!, 
      tag: selectCategory!, 
      diet: int.parse(dietController.text), 
      duration: _duration.ddhhmmss, 
      ingredients: ingredientController.map((e) => e.text).toList(), 
      steps: stepController.map((e) => e.text).toList(), 
      createdAt: DateTime.now(), 
      likes: [],
    );
    await _foodServices.addFood(context, food);
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
                onAcceptTap: () => Navigator.pushReplacement(context, checkDeviceRoute(myFoodScreen)), 
                onCancelTap: () => Navigator.pop(context)
              );
            }, 
            icon: Icon(Icons.arrow_back, size: 20)
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
            DropdownButton(
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
                      height: 30,
                      width: 50,
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
                          hintText: "Số lượng",
                          hintStyle: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w800
                          )
                        ),
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 14
                        ),
                      ),
                    ),
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
                    width: 100,
                    height: 30,
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
            ListView.builder(
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
                    prefixIcon: Text(
                      "${index + 1}",
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 14
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
                height: 30,
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
            ListView.builder(
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
                    prefixIcon: Text(
                      "${index + 1}",
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 14
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
                height: 30,
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