import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/services/firestore/comment/comment_services.dart';
import 'package:food_recipe_app/views/main/food_details/user_interaction/component/edit_comment_dialog.dart';
import 'package:food_recipe_app/views/main/settings/selection.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_report_modal.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';

class CommentSelection {
  static void onDelete(BuildContext context, CommentServices services, String id) async{
    await services.deleteComment(context, id).then((_){
      Message.showToast("Đã xóa bình luận");
      Navigator.pop(context);
    }); 
    await Future.delayed(Duration(seconds: 2), (){
      Navigator.pop(context);
    });  
  }
  static void showSelectionWithCurrentUser(BuildContext context, CommentModel comment, String foodId){
    final commentServices = CommentServices(foodId: foodId);
    showDialog(
      context: context, 
      builder: (context) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        surfaceTintColor: AppColors.white,
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            ListView(
              children: [
                Selection(
                  onTap: () => EditCommentDialog.checkDeviceEditComment(context, comment, foodId), 
                  icon: Icons.edit, 
                  title: "Sửa"
                ),
                Selection(
                  onTap: () {
                    ShowYesnoDialog.checkDeviceDialog(
                      context, 
                      title: "Xóa bình luận", 
                      content: "Bạn có chắc chắn muốn xóa không?", 
                      onAcceptTap: () => onDelete(context, commentServices, comment.commentId),
                      onCancelTap: () => Navigator.pop(context)
                    );
                  }, 
                  icon: Icons.delete, 
                  title: "Xóa"
                ),
                Selection(
                  onTap: () => Clipboard.setData(ClipboardData(text: comment.content)), 
                  icon: Icons.copy, 
                  title: "Sao chép"
                )
              ],
            )
          ],
        ),
      )
    );
  }
  static void showGeneralSelection(BuildContext context, CommentModel comment){
    showDialog(
      context: context, 
      builder: (context) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        surfaceTintColor: AppColors.white,
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            ListView(
              children: [
                Selection(
                  onTap: () async => await showReportModal(context, "bình luận ${comment.content}", comment.userName, null), 
                  icon: Icons.report_problem, 
                  title: "Báo cáo/Chặn"
                ),
                Selection(
                  onTap: () => Clipboard.setData(ClipboardData(text: comment.content)), 
                  icon: Icons.copy, 
                  title: "Sao chép"
                )
              ],
            )
          ],
        ),
      )
    );
  }
}