import 'dart:io';

import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/community/comment_model.dart';
import 'package:food_recipe_app/model/food/food_model.dart';
import 'package:food_recipe_app/views/main/food_details/user_interaction/component/comment_widget.dart';

class ReplyCommentPage extends StatefulWidget {
  final CommentModel comment;
  final FoodModel food;
  const ReplyCommentPage({super.key, required this.comment, required this.food});

  @override
  State<ReplyCommentPage> createState() => _ReplyCommentPageState();
}

class _ReplyCommentPageState extends State<ReplyCommentPage> {
  List<dynamic> userNotificationList = [];
  final _commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void pushReplyNotifications(){
    userNotificationList.add(widget.comment.userName);
    notificationData.pushInteractNotifications(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      title: widget.food.title, 
      body: "${currentUser.displayName} đã trả lời bình luận của bạn", 
      from: currentUser.displayName ?? "", 
      to: userNotificationList, 
      type: "Trả lời bình luận",
      mainData: widget.comment.toMap(),
      extraData: widget.food.toMap(), 
      isRead: false, 
      createdAt: DateTime.now()
    );
  }
  void onAddReply(){
    CommentModel comment = CommentModel(
      commentId: widget.comment.commentId, 
      userId: currentUser.uid, 
      avatar: currentUser.photoURL ?? "", 
      userName: currentUser.displayName ?? "", 
      content: _commentController.text, 
      likesList: [], 
      replies: [], 
      createdAt: DateTime.now()
    );
    commentServices.addReplyComment(context, comment, widget.food.foodId);
    // pushReplyNotifications();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, 
              size: 25
            )
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        title: Text(
          "${"replyComment".tr(widget.comment.userName)} (${widget.comment.replies.length})",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800
          ),
        ),
        centerTitle: true,
      ),
      body: CommentBox(
        formKey: formKey,
        userImage: CommentBox.commentImageParser(imageURLorPath: currentUser.photoURL ?? ""),
        labelText: "writeComment".tr(),
        errorText: "commentInvalid".tr(),
        withBorder: true,
        sendButtonMethod: () {
          if (formKey.currentState!.validate()){
            onAddReply();
            _commentController.clear();
            FocusScope.of(context).unfocus();
          }
        },
        commentController: _commentController,
        backgroundColor: theme.appBarTheme.backgroundColor,
        textColor: theme.appBarTheme.foregroundColor,
        sendWidget: Icon(
          Icons.send, 
          size: 30, 
          color: AppColors.white
        ),
        child: ListView.builder(
          itemCount: widget.comment.replies.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          hitTestBehavior: HitTestBehavior.translucent,
          clipBehavior: Clip.hardEdge,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) => CommentWidget(
            comment: widget.comment.replies[index], 
            food: widget.food,
            isReply: true,
          ),
        )
      )
    );
  }
}