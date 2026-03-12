import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/routes.dart';

Future<void> showImageChoiceBottomSheet(BuildContext context, String fileUrl) async{
  return await showModalBottomSheet(
    context: context, 
    // ignore: deprecated_member_use
    barrierColor: AppColors.black.withOpacity(0.25),
    builder: (context) => ShowImageSheet(fileUrl: fileUrl)
  );
}

class ShowImageSheet extends StatelessWidget {
  final String fileUrl;
  const ShowImageSheet({super.key, required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isImage = fileUrl.contains("jpg") || fileUrl.contains("jpeg") || fileUrl.contains("png");
    return Container(
      padding: EdgeInsets.only(bottom: 15, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        color: theme.colorScheme.primary
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
              if (!isImage) return;
              Navigator.push(context, checkDeviceRoute(fullScreenImage(fileUrl)));
              await Future.delayed(Duration(seconds: 2), () => Navigator.pop(context));
            },
            child: Text("viewImage".tr(),
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
            onPressed: () {
              if (isImage) {
                imageServices.downloadImage(context, fileUrl);
              }
              imageServices.downloadVideo(context, fileUrl);
            },
            child: Text("downloadImage".tr(),
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