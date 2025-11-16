import 'dart:collection';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/convert.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_image_picker.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class AddCookbookPage extends StatefulWidget {
  const AddCookbookPage({super.key});

  @override
  State<AddCookbookPage> createState() => _AddCookbookPageState();
}

class _AddCookbookPageState extends State<AddCookbookPage> {
  File? image;
  String imageURL = "";
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  HashSet<FoodModel> choices = HashSet();
  bool canMultiSelected = false;
  void onMultiSelect(FoodModel food){
    if (choices.contains(food)){
      choices.remove(food);
    } else {
      choices.add(food);
    }
    setState(() {});
  }
  String get getSelectedItemCount {
    return choices.isEmpty 
      ? "Chưa chọn món ăn nào" 
      : "${choices.length.toString()} món ăn được chọn";
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  } 
  void add() async{
    context.loaderOverlay.show();
    if (_titleController.text.isEmpty){
      Message.showToast("Tên nhật ký là bắt buộc");
      context.loaderOverlay.hide();
      return;
    }
    if (choices.isEmpty) {
      Message.showToast("Bạn phải chọn ít nhất 1 món ăn");
      context.loaderOverlay.hide();
      return;
    }
    if (image != null) {
      imageURL = await imageServices.uploadImage(context, image!, cookbookFolder);
    }
    CookbookModel cookbook = CookbookModel(
      cookbookId: generateRandomString(22), 
      cookbookImage: image == null && imageURL.isEmpty ? foodDefaultImage : imageURL, 
      cookbookName: _titleController.text, 
      description: _descriptionController.text, 
      userId: currentUser.uid, 
      createdAt: DateTime.now(), 
      foodsList: choices.toList()
    );
    context.read<CookbookState>().createCookbook(cookbook);
    if (!mounted) return;
    context.loaderOverlay.hide();
    Message.showScaffoldMessage(context, "Thêm thành công", AppColors.green);
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          canMultiSelected ? getSelectedItemCount : "Tạo sổ tay mới",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: canMultiSelected ? IconButton(
            onPressed: (){
              choices.clear();
              canMultiSelected = false;
              setState(() {});
            }, 
            icon: Icon(Icons.close, size: 20)
          ) : IconButton(
            onPressed: () => ShowYesnoDialog.checkDeviceDialog(
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
            ),
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, 
              size: 20
            )
          ),
        ),
        actions: [
          Visibility(
            visible: choices.isNotEmpty,
            child: IconButton(
              onPressed: () {
                choices.forEach((food) => onMultiSelect(food));
              }, 
              icon: Icon(Icons.select_all, size: 20)
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: image == null && imageURL.isEmpty
              ? InkWell(
                onTap: () async{
                  final imagePicked = await showImagePickerModal(context);
                  if (imagePicked != null){
                    setState(() {
                      image = imagePicked;
                    });
                  }
                },
                child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.black)
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                ),
              )
              : image != null ? InkWell(
                onTap: () async{
                  final imagePicked = await showImagePickerModal(context);
                  if (imagePicked != null){
                    setState(() {
                      image = imagePicked;
                    });
                  }
                },
                child: ClipRRect(
                  child: Image.file(image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ) : InkWell(
                onTap: () async{
                  final imagePicked = await showImagePickerModal(context);
                  if (imagePicked != null){
                    setState(() {
                      image = imagePicked;
                    });
                  }
                },
                child: ClipRRect(
                  child: Image.network(imageURL,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Tên nhật ký",
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.secondary)
                ),
                hintText: "Nhập tên nhật ký",
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
              controller: _descriptionController,
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
                hintText: "Mô tả về nhật ký đó",
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
            StreamBuilder(
              stream: foodServices.getFood(context), 
              builder: (context, snapshot){
                if (!snapshot.hasData || snapshot.hasError){
                  return SizedBox.shrink();
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: AppColors.yellow));
                } else {
                  List<FoodModel> foodData = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: foodData.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => onMultiSelect(foodData[index]),
                      onLongPress: (){
                        canMultiSelected = true;
                        onMultiSelect(foodData[index]);
                      },
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
                                width: 50,
                                height: 50,
                                errorWidget: (context, url, error) => Image.asset(foodDesignImage),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              foodData[index].title,
                              style: TextStyle(
                                color: choices.contains(foodData[index]) ? AppColors.white : theme.colorScheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w800
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
                onPressed: add, 
                child: Text(
                  "Thêm",
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