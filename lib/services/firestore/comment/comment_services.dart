import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/services/firestore/comment/comment_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class CommentServices extends CommentRepo{

  CollectionReference<Map<String, dynamic>> commentCollection(String foodId){
    return FirebaseFirestore.instance
      .collection("food_recipe")
      .doc(foodId)
      .collection("comment");
  }

  @override
  Future<void> addComment(BuildContext context, CommentModel comment, String foodId) async{
    // TODO: implement addComment
    try {
      await commentCollection(foodId).doc(comment.commentId).set(comment.toMap()); 
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
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
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
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
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
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
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
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
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
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
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
  @override
  Future<void> updateReplyComment(BuildContext context, CommentModel comment, String foodId) async{
    // TODO: implement updateReplyComment
    try {
      await commentCollection(foodId).doc(comment.commentId).update({
        'replies': [comment.updateMap()]
      });
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
}