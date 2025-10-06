import 'package:flutter/material.dart';
import 'package:food_recipe_app/model/comment_model.dart';

abstract class CommentRepo {
  Future<void> addComment(BuildContext context, CommentModel comment);
  Future<void> updateComment(BuildContext context, CommentModel comment);
  Future<void> deleteComment(BuildContext context, String commentId);
  Stream<List<CommentModel>> getComment(BuildContext context);
}