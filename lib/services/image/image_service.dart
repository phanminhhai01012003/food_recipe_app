import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:food_recipe_app/services/image/image_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:image_picker/image_picker.dart';

class ImageService extends ImageRepo{
  @override
  Future<void> pickImage(BuildContext context, bool isCamera, File? image) async{
    // TODO: implement pickImage
    try {
      final picker = ImagePicker();
      final imagePicker = await picker.pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
      if (imagePicker != null) {
        image = File(imagePicker.path);
      } 
    } catch (e){
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> uploadImage(BuildContext context, File? image, String folder, String imageUrl) async{
    // TODO: implement uploadImage
    try {
      if (image != null) {
        String fileName = image.path.split("/").last;
        Reference ref = FirebaseStorage.instance.ref().child("$folder/$fileName");
        UploadTask uploadTask = ref.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
}