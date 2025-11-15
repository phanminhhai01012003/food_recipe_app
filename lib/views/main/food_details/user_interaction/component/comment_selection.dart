import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/services/firestore/comment/comment_services.dart';
import 'package:food_recipe_app/views/main/food_details/user_interaction/component/edit_comment_dialog.dart';
import 'package:food_recipe_app/views/main/settings/selection.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_report_modal.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';

class CommentSelection {
  static final commentServices = CommentServices();
  static void onDelete(
    BuildContext context, 
    CommentModel comment, 
    String commentId, 
    String foodId, 
    bool isReply
  ) async{
    if (isReply) {
      await commentServices.deleteReplyComment(context, comment, foodId).then((_){
        Message.showToast("Đã xóa bình luận");
        Navigator.pop(context);
      });
    } else {
      await commentServices.deleteComment(context, commentId, foodId).then((_){
        Message.showToast("Đã xóa bình luận");
        Navigator.pop(context);
      });
    }
    await Future.delayed(Duration(seconds: 2), (){
      Navigator.pop(context);
    });  
  }
  static void showSelectionWithCurrentUser(
    BuildContext context, 
    CommentModel comment, 
    String foodId, 
    bool isReply
  ){
    final theme = Theme.of(context);
    showDialog(
      context: context, 
      builder: (context) => Dialog(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        surfaceTintColor: theme.colorScheme.primary,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 175,
          child: Column(
            children: [
              Selection(
                onTap: () => EditCommentDialog.checkDeviceEditComment(context, comment, foodId, isReply), 
                icon: Icons.edit, 
                title: "Sửa"
              ),
              Selection(
                onTap: () {
                  ShowYesnoDialog.checkDeviceDialog(
                    context, 
                    title: "Xóa bình luận", 
                    content: "Bạn có chắc chắn muốn xóa không?", 
                    onAcceptTap: () => onDelete(context, comment, comment.commentId, foodId, isReply),
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
          ),
        ),
      )
    );
  }
  static void showGeneralSelection(BuildContext context, CommentModel comment){
    final theme = Theme.of(context);
    showDialog(
      context: context, 
      builder: (context) => Dialog(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        surfaceTintColor: theme.colorScheme.primary,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 125,
          child: Column(
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
          ),
        ),
      )
    );
  }
}