import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/services/image/image_service.dart';

Future<void> showImagePickerModal(BuildContext context, File image) async{
  return await showModalBottomSheet(
    context: context,
    // ignore: deprecated_member_use
    barrierColor: AppColors.black.withOpacity(0.5),
    builder: (context) => ShowImagePicker(image: image)
  );
}

class ShowImagePicker extends StatelessWidget {
  final File image;
  const ShowImagePicker({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final imageService = ImageService();
    return Container(
      padding: EdgeInsets.only(bottom: 15, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        color: AppColors.white
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16, top: 10),
            decoration: ShapeDecoration(
              shape: StadiumBorder(),
              color: AppColors.grey
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
              backgroundColor: AppColors.yellow,
              foregroundColor: AppColors.white
            ),
            onPressed: () async{
              await imageService.pickImage(context, true, image);
            },
            child: Text("Chụp ảnh",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
              backgroundColor: AppColors.yellow,
              foregroundColor: AppColors.white
            ),
            onPressed: () async{
              await imageService.pickImage(context, false, image);
            },
            child: Text("Chọn ảnh",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800
              ),
            ),
          )
        ],
      ),
    );
  }
}