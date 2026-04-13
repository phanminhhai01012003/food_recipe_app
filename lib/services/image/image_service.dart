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
  Future<File?> pickVideo(BuildContext context, bool isVideo) async{
    // TODO: implement pickVideo
    try {
      final picker = ImagePicker();
      final imagePicker = await picker.pickVideo(source: isVideo ? ImageSource.camera : ImageSource.gallery);
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
        await Gal.requestAccess().then((value){
          if (!value) {
            Message.showToast("storagePermissionDenied".tr());
          } else {
            Message.showToast("storagePermissionSuccess".tr());
          }
        });
      }
      final tempDir = await getApplicationDocumentsDirectory();
      final fileName = Uri.parse(imageUrl).pathSegments.last;
      final path = "${tempDir.path}/$fileName";
      await dio.download(
        imageUrl, 
        path,
        onReceiveProgress: (count, total) {
          if (total != -1){
            Message.showToast("${(count / total * 100).toStringAsFixed(0)}%");
          }
        },
      ).then((value) => Logger.log({
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

  @override
  Future<void> downloadVideo(BuildContext context, String videoUrl) async{
    // TODO: implement downloadVideo
    try {
      final dio = Dio();
      final hasAccess = await Gal.hasAccess();
      if(!hasAccess){
        await Gal.requestAccess().then((value){
          if (!value) {
            Message.showToast("storagePermissionDenied".tr());
          } else {
            Message.showToast("storagePermissionSuccess".tr());
          }
        });
      }
      final tempDir = await getApplicationDocumentsDirectory();
      final fileName = Uri.parse(videoUrl).pathSegments.last;
      final path = "${tempDir.path}/$fileName";
      await dio.download(
        videoUrl, 
        path,
        onReceiveProgress: (count, total) {
          if (total != -1){
            Message.showToast("${(count / total * 100).toStringAsFixed(0)}%");
          }
        },
      ).then((value) => Logger.log({
        "headers": value.headers,
        "data": value.data,
        "extra": value.extra,
        "statusCode": value.statusCode,
        "statusMessage": value.statusMessage
      }));
      await Gal.putVideo(path);
      Message.showScaffoldMessage(context, "downloadImageSuccess".tr(), AppColors.green);
      Navigator.pop(context);
    } catch (e) {
      Message.showScaffoldMessage(context, "downloadImageFail".tr(), AppColors.red);
      Logger.log("Error to download image: $e");
      rethrow;
    }
  }

}