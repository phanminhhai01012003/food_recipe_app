import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/logger.dart';
import 'package:food_recipe_app/services/image/image_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageService extends ImageRepo{
  @override
  Future<File?> pickImage(BuildContext context, bool isCamera) async{
    // TODO: implement pickImage
    try {
      final picker = ImagePicker();
      final imagePicker = await picker.pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
      if (imagePicker == null) return null;
      return File(imagePicker.path);
    } catch (e){
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<String> uploadImage(BuildContext context, File? image, String folder) async{
    // TODO: implement uploadImage
    try {
      if (image == null) return "";
      String fileName = image.path.split("/").last;
      Reference ref = FirebaseStorage.instance.ref().child("$folder/$fileName");
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
  @override
  Future<void> downloadImage(BuildContext context, String imageUrl) async{
    // TODO: implement downloadImage
    try {
      final dio = Dio();
      final hasAccess = await Gal.hasAccess();
      if(!hasAccess){
        await Gal.requestAccess();
      }
      final tempDir = await getApplicationDocumentsDirectory();
      final path = "${tempDir.path}/$imageUrl";
      await dio.download(imageUrl, path).then((value) => Logger.log({
        "headers": value.headers,
        "data": value.data,
        "extra": value.extra,
        "statusCode": value.statusCode,
        "statusMessage": value.statusMessage
      }));
      await Gal.putImage(path);
      Message.showScaffoldMessage(context, "downloadImageSuccess".tr(), AppColors.green);
      Navigator.pop(context);
    } catch (e) {
      Message.showScaffoldMessage(context, "downloadImageFail".tr(), AppColors.red);
      Logger.log("Error to download image: $e");
      rethrow;
    }
  }

}