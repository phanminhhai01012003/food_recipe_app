import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/services/firestore/comment/comment_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class CommentServices extends CommentRepo{
  late final String foodId;
  late final CollectionReference<Map<String, dynamic>> commentCollection;

  CommentServices({required this.foodId}) {
    commentCollection = FirebaseFirestore.instance
      .collection("food_recipe")
      .doc(foodId)
      .collection("comment");
  }

  @override
  Future<void> addComment(BuildContext context, CommentModel comment) async{
    // TODO: implement addComment
    try {
      await commentCollection.doc(comment.commentId).set(comment.toMap()); 
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(BuildContext context, String commentId) async{
    // TODO: implement deleteComment
    try {
      await commentCollection.doc(commentId).delete();
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Stream<List<CommentModel>> getComment(BuildContext context) {
    // TODO: implement getComment
    try {
      return commentCollection
        .snapshots()
        .map((ss) => ss.docs.map((e) => CommentModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> updateComment(BuildContext context, CommentModel comment) async{
    // TODO: implement updateComment
    try {
      await commentCollection.doc(comment.commentId).update(comment.updateMap());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
}