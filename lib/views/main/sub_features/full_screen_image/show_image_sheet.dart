import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/logger.dart';
import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';

Future<void> showImageChoiceBottomSheet(BuildContext context, String imageUrl) async{
  return await showModalBottomSheet(
    context: context, 
    // ignore: deprecated_member_use
    barrierColor: AppColors.black.withOpacity(0.25),
    builder: (context) => ShowImageSheet(imageUrl: imageUrl)
  );
}

class ShowImageSheet extends StatelessWidget {
  final String imageUrl;
  const ShowImageSheet({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            onPressed: () {
              Navigator.push(context, checkDeviceRoute(fullScreenImage(imageUrl)));
            },
            child: Text("Xem ảnh",
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
            onPressed: () => onDownload(context),
            child: Text("Tải xuống",
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

  void onDownload(BuildContext context) async {
    try {
      final dio = Dio();
      final hasAccess = await Gal.hasAccess();
      if(!hasAccess){
        await Gal.requestAccess();
      }
      final tempDir = await getTemporaryDirectory();
      final path = "${tempDir.path}/$imageUrl";
      await dio.download(imageUrl, path);
      await Gal.putImage(path);
      Message.showScaffoldMessage(context, "Tải ảnh thành công", AppColors.green);
      Navigator.pop(context);
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi khi tải ảnh", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
}