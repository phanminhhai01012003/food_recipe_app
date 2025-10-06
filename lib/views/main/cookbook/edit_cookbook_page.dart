import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';
import 'package:food_recipe_app/model/food_model.dart';

class EditCookbookPage extends StatefulWidget {
  final CookbookModel cookbook;
  const EditCookbookPage({super.key, required this.cookbook});

  @override
  State<EditCookbookPage> createState() => _EditCookbookPageState();
}

class _EditCookbookPageState extends State<EditCookbookPage> {
  File? image;
  String? imageUrl;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageUrl = widget.cookbook.cookbookImage;
    titleController.text = widget.cookbook.cookbookName;
    descriptionController.text = widget.cookbook.description;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}