import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';

void showNoInternetDialog(BuildContext context, {required VoidCallback onPressed}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.black.withValues(alpha: 0.5),
    builder: (context) => Dialog(
      backgroundColor: AppColors.white,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetAnimationCurve: Easing.legacyAccelerate,
      insetAnimationDuration: Duration(milliseconds: 200),
      insetPadding: EdgeInsets.all(12),
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Icon(Icons.wifi_off, color: AppColors.red),
          ),
          SizedBox(height: 30),
          Text("Không có internet",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700
            ),
          ),
          SizedBox(height: 5),
          Text("Vui lòng kiểm tra kết nối của bạn và thử lại",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.75,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
              ),
              child: Text("Thử lại",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700
                ),
              )
            ),
          )
        ],
      ),
    )
  );
}