import 'package:flutter/material.dart';
import 'package:food_recipe_app/model/comment_model.dart';

abstract class CommentRepo {
  Future<void> addComment(BuildContext context, CommentModel comment, String foodId);
  Future<void> updateComment(BuildContext context, CommentModel comment, String foodId);
  Future<void> deleteComment(BuildContext context, String commentId, String foodId);
  Future<void> addReplyComment(BuildContext context, CommentModel comment, String foodId);
  Future<void> updateReplyComment(BuildContext context, CommentModel comment, String foodId);
  Future<void> deleteReplyComment(BuildContext context, CommentModel comment, String foodId);
  Stream<List<CommentModel>> getComment(BuildContext context, String foodId);
}