import 'dart:collection';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/services/firestore/food_recipe/food_services.dart';
import 'package:food_recipe_app/services/image/image_service.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_image_picker.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
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
  File? image;
  String? imageURL;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final imageServices = ImageService();
  final foodServices = FoodServices();
  HashSet<FoodModel> choices = HashSet();
  bool canMultiSelected = false;
  void onMultiSelect(FoodModel food){
    if (canMultiSelected){
      if (choices.contains(food)){
        choices.remove(food);
      } else {
        choices.add(food);
      }
      setState(() {});
    }
  }
  String get getSelectedItemCount {
    return choices.isEmpty 
      ? "Chưa chọn món ăn nào" 
      : "${choices.length.toString()} món ăn được chọn";
  }
  void add() async{
    context.loaderOverlay.show();
    if (_titleController.text.isEmpty){
      Message.showToast("Tên nhật ký là bắt buộc");
      context.loaderOverlay.hide();
      return;
    }
    imageURL = await imageServices.uploadImage(context, image!);
    CookbookModel cookbook = CookbookModel(
      cookbookId: widget.cookbook.cookbookId, 
      cookbookImage: imageURL!, 
      cookbookName: _titleController.text, 
      description: _descriptionController.text, 
      userId: widget.cookbook.userId, 
      createdAt: widget.cookbook.createdAt, 
      foodsList: choices.toList()
    );
    context.read<CookbookState>().createCookbook(cookbook);
    if (!mounted) return;
    Message.showScaffoldMessage(context, "Cập nhật thành công", AppColors.green);
    Navigator.pop(context);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageURL = widget.cookbook.cookbookImage;
    _titleController.text = widget.cookbook.cookbookName;
    _descriptionController.text = widget.cookbook.description;
    choices = HashSet.from(widget.cookbook.foodsList);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          canMultiSelected ? getSelectedItemCount : "Chỉnh sửa thông tin",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
        ),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        leading: canMultiSelected ? IconButton(
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
            onAcceptTap: () => Navigator.pushReplacement(context, checkDeviceRoute(cookbookPage)), 
            onCancelTap: () => Navigator.pop(context)
          ),
          icon: Icon(Icons.arrow_back, size: 20)
        ),
        actions: [
          Visibility(
            visible: choices.isNotEmpty,
            child: IconButton(
              onPressed: () {
                choices.forEach((food){
                  onMultiSelect(food);
                });
              }, 
              icon: Icon(Icons.select_all, size: 20)
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Center(
              child: image == null && imageURL!.isEmpty
              ? InkWell(
                onTap: () => showImagePickerModal(context, image!),
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
            Text(
              "Tên nhật ký",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _titleController,
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
                hintText: "Nhập tên nhật ký",
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
                  borderSide: BorderSide(color: AppColors.black)
                ),
                hintText: "Mô tả về nhật ký đó",
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
                        color: canMultiSelected ? AppColors.green : AppColors.white,
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
                                  color: canMultiSelected ? AppColors.white : AppColors.black,
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
            )
          ],
        ),
      )
    );
  }
}