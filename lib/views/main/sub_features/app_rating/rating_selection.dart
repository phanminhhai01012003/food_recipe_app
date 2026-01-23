import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/model/rating_model.dart';
import 'package:food_recipe_app/services/firestore/rate/rate_services.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_report_modal.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class RatingSelection {
  static RateServices rateServices = RateServices();
  static void showCurrentUserRateSelection(BuildContext context, RatingModel rate) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.5), 
      builder: (context) => Dialog(
        backgroundColor: theme.colorScheme.primary,
        surfaceTintColor: theme.colorScheme.primary,
        alignment: Alignment.center,
        insetAnimationCurve: Easing.legacyAccelerate,
        insetAnimationDuration: Duration(milliseconds: 200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, checkDeviceRoute(ratingScreen(rate)));
              },
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.yellow
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 20,
                      color: AppColors.white,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Sửa",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                ShowYesnoDialog.checkDeviceDialog(
                  context, 
                  title: "Xóa đánh giá", 
                  content: "Bạn chắc chắn muốn xóa đánh giá của bạn chứ!", 
                  onAcceptTap: () async{
                    await rateServices.deleteRating(context, rate.ratingId).then((_){
                      Message.showScaffoldMessage(context, "Đã xóa", AppColors.green);
                      Navigator.pop(context);
                    });
                  }, 
                  onCancelTap: () => Navigator.pop(context)
                );
              },
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.red
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      size: 20,
                      color: AppColors.white,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Xóa",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Clipboard.setData(ClipboardData(text: rate.content)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.blue
                ),
                width: 75,
                height: 75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.copy,
                      size: 20,
                      color: AppColors.white,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Sao chép",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
  static void showGeneralRateSelection(BuildContext context, RatingModel rate) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.5), 
      builder: (context) => Dialog(
        backgroundColor: theme.colorScheme.primary,
        surfaceTintColor: theme.colorScheme.primary,
        alignment: Alignment.center,
        insetAnimationCurve: Easing.legacyAccelerate,
        insetAnimationDuration: Duration(milliseconds: 200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async{
                await showReportModal(context, "đánh giá ${rate.content}", rate.userName, null);
              },
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.blue
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.report_problem,
                      size: 20,
                      color: AppColors.white,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Báo cáo",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Clipboard.setData(ClipboardData(text: rate.content)),
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.blue
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.copy,
                      size: 20,
                      color: AppColors.white,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Sao chép",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}