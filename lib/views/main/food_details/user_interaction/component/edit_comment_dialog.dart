import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/services/firestore/comment/comment_services.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class EditCommentDialog {
  static final commentServices = CommentServices();
  static void showMaterialEdit(
    BuildContext context, 
    CommentModel comment, 
    String id, 
    bool isReply
  ){
    final theme = Theme.of(context);
    final commentController = TextEditingController(text: comment.content);
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(12),
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          "editComment".tr(),
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: commentController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.secondary)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.green)
              ),
              hintText: "commentInput".tr(),
              hintStyle: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
            onPressed: () async{
              await onUpdateComment(
                context, 
                content: commentController.text, 
                comment: comment,
                id: id,
                isReply: isReply
              );
            },
            child: Text("send".tr())
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text("cancel".tr(), style: TextStyle(color: AppColors.black))
          )
        ],
      )
    );
  }

  static void showCupertinoEdit(
    BuildContext context, 
    CommentModel comment, 
    String id, 
    bool isReply
  ) {
    final commentController = TextEditingController(text: comment.content);
    final theme = Theme.of(context);
    showDialog(
      context: context, 
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          "editComment".tr(),
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: commentController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.secondary)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.green)
              ),
              hintText: "commentInput".tr(),
              hintStyle: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () async{
              await onUpdateComment(
                context,  
                content: commentController.text, 
                comment: comment,
                id: id,
                isReply: isReply
              );
            },
            child: Text("send".tr(), style: TextStyle(color: AppColors.blue)),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text("cancel".tr(), style: TextStyle(color: AppColors.red)),
          )
        ],
      )
    );
  }
  
  static void checkDeviceEditComment(BuildContext context, CommentModel comment, String id, bool isReply) => Platform.isAndroid 
    ? showMaterialEdit(context, comment, id, isReply) 
    : showCupertinoEdit(context, comment, id, isReply);
  
  static Future<void> onUpdateComment(
    BuildContext context, {
      required String content, 
      required CommentModel comment,
      required String id,
      required bool isReply
    }) async{
    if (content.isEmpty) return;
    if (isReply) {
      await commentServices.updateReplyComment(context, comment, id).then((_){
        Message.showToast("updated".tr());
        Navigator.pop(context);
      });
    } else {
      await commentServices.updateComment(context, comment, id).then((_){
        Message.showToast("updated".tr());
        Navigator.pop(context);
      });
    }
    await Future.delayed(Duration(seconds: 2), (){
      Navigator.pop(context);
    });
  }
}