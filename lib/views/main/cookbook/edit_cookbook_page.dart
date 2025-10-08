import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/services/image/image_service.dart';
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
    Message.showScaffoldMessage(context, "Thêm thành công", AppColors.green);
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
      appBar: AppBar(),
    );
  }
}