import 'dart:io';

import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:food_recipe_app/services/image/image_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';

class ImageService extends ImageRepo{
  @override
  Future<void> pickImage(BuildContext context, bool isCamera, File image) async{
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
  Future<String?> uploadImage(BuildContext context, File image) async{
    // TODO: implement uploadImage
    try {
      File file = File(image.path);
      var cloudinary = Cloudinary.fromStringUrl('cloudinary://$apiKey:$apiSecret@$cloudName');
      var response = await cloudinary.uploader().upload(
        file,
        params: UploadParams(folder: folder)
      );
      return response?.data?.url ?? "";
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
}