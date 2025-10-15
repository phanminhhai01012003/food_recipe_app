import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/services/firestore/comment/comment_services.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class EditCommentDialog {
  static final commentServices = CommentServices();
  static void showMaterialEdit(BuildContext context, CommentModel comment, String id){
    final commentController = TextEditingController(text: comment.content);
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(12),
        backgroundColor: Colors.white,
        title: Text(
          "Sửa bình luận",
          style: TextStyle(
            color: AppColors.black,
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
                borderSide: BorderSide(color: AppColors.black)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.green)
              ),
              hintText: "Nhập bình luận",
              hintStyle: TextStyle(
                color: AppColors.black,
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
                id: id
              );
            },
            child: Text("Gửi")
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text("Hủy", style: TextStyle(color: AppColors.black))
          )
        ],
      )
    );
  }

  static void showCupertinoEdit(BuildContext context, CommentModel comment, String id) {
    final commentController = TextEditingController(text: comment.content);
    showDialog(
      context: context, 
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          "Sửa bình luận",
          style: TextStyle(
            color: AppColors.black,
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
                borderSide: BorderSide(color: AppColors.black)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.green)
              ),
              hintText: "Nhập bình luận",
              hintStyle: TextStyle(
                color: AppColors.black,
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
                id: id
              );
            },
            child: Text("Gửi", style: TextStyle(color: AppColors.blue)),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text("Hủy", style: TextStyle(color: AppColors.red)),
          )
        ],
      )
    );
  }
  
  static void checkDeviceEditComment(BuildContext context, CommentModel comment, String id) => Platform.isAndroid 
    ? showMaterialEdit(context, comment, id) 
    : showCupertinoEdit(context, comment, id);
  
  static Future<void> onUpdateComment(
    BuildContext context, {
      required String content, 
      required CommentModel comment,
      required String id
    }) async{
    if (content.isEmpty) return;
    await commentServices.updateComment(context, comment, id).then((_){
      Message.showToast("Đã cập nhật");
      Navigator.pop(context);
    });
    await Future.delayed(Duration(seconds: 2), (){
      Navigator.pop(context);
    });
  }
}