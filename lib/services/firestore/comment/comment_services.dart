import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/utils/logger.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/services/firestore/comment/comment_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class CommentServices extends CommentRepo{

  @override
  Future<void> addComment(BuildContext context, CommentModel comment, String foodId) async{
    // TODO: implement addComment
    try {
      await commentCollection(foodId).doc(comment.commentId).set(comment.toMap()); 
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(BuildContext context, String commentId, String foodId) async{
    // TODO: implement deleteComment
    try {
      await commentCollection(foodId).doc(commentId).delete();
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Stream<List<CommentModel>> getComment(BuildContext context, String foodId) {
    // TODO: implement getComment
    try {
      return commentCollection(foodId)
        .snapshots()
        .map((ss) => ss.docs.map((e) => CommentModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> updateComment(BuildContext context, CommentModel comment, String foodId) async{
    // TODO: implement updateComment
    try {
      await commentCollection(foodId).doc(comment.commentId).update(comment.updateMap());
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
  @override
  Future<void> addReplyComment(BuildContext context, CommentModel comment, String foodId) async{
    // TODO: implement addReplyComment
    try {
      await commentCollection(foodId).doc(comment.commentId).update({
        'replies': FieldValue.arrayUnion([comment.toMap()])
      });
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
  @override
  Future<void> deleteReplyComment(BuildContext context, CommentModel comment, String foodId) async{
    // TODO: implement deleteReplyComment
    try {
      await commentCollection(foodId).doc(comment.commentId).update({
        'replies': FieldValue.arrayRemove([comment.toMap()])
      });
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
  @override
  Future<void> updateReplyComment(BuildContext context, CommentModel comment, String foodId) async{
    // TODO: implement updateReplyComment
    try {
      final document = await commentCollection(foodId).doc(comment.commentId).get();
      if (document.exists) {
        final data = document.data();
        if (data != null && data.containsKey(comment)){
          List<dynamic> currentReplies = List.from(data['replies'] ?? []);
          int index = -1;
          for(int i = 0; i < currentReplies.length; i++) {
            if (currentReplies[i] is Map) {
              index = i;
              break;
            }
          }
          if (index != -1){
            Map<String, dynamic> item = Map.from(currentReplies[index]);
            item.addAll(comment.updateMap());
            currentReplies[index] = item;
            await commentCollection(foodId).doc(comment.commentId).update({'replies': currentReplies});
          }
        }
      }
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteAllComment(BuildContext context, String foodId) async{
    // TODO: implement deleteAllComment
    try {
      final document = await commentCollection(foodId).get();
      final batch = FirebaseFirestore.instance.batch();
      for(var data in document.docs){
        batch.delete(data.reference);
      }
      await batch.commit();
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
}