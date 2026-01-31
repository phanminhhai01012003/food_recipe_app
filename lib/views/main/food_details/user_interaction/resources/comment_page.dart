import 'dart:io';

import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/convert.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/views/main/food_details/user_interaction/component/comment_widget.dart';
import 'package:food_recipe_app/widget/load_data/load_data.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class CommentPage extends StatefulWidget {
  final FoodModel food;
  const CommentPage({super.key, required this.food});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Future<int> get getCommentCount async{
    final snapshot = await commentCollection(widget.food.foodId).count().get();
    return snapshot.count!;
  }
  void onAddComment() async{
    CommentModel comment = CommentModel(
      commentId: generateRandomString(23),
      userId: currentUser.uid,
      avatar: currentUser.photoURL!, 
      userName: currentUser.displayName!, 
      content: _commentController.text,
      likesList: [],
      replies: [],
      createdAt: DateTime.now()
    );
    await commentServices.addComment(context, comment, widget.food.foodId).then((_) async{
      Message.showScaffoldMessage(context, "sendCommentSuccess".tr(), AppColors.green);
      // pushCommentNotifications();
    });
  }
  void pushCommentNotifications(){
    notificationData.pushInteractNotifications(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "${currentUser.displayName} đã thích bài viết của bạn",
      body: "Nhấn để xem",
      from: currentUser.displayName!,
      to: widget.food.userName,
      type: "Bình luận bài viết",
      extraData: widget.food.toMap(),
      isRead: false,
      createdAt: DateTime.now()
    );
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
        title: commentTitle,
        centerTitle: true,
      ),
      body: CommentBox(
        formKey: formKey,
        userImage: CommentBox.commentImageParser(imageURLorPath: currentUser.photoURL!),
        labelText: "writeComment".tr(),
        errorText: "commentInvalid".tr(),
        withBorder: true,
        sendButtonMethod: () {
          if (formKey.currentState!.validate()){
            onAddComment();
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
        child: StreamBuilder(
          stream: commentServices.getComment(context, widget.food.foodId), 
          builder: (context, snapshot){
            if (!snapshot.hasData || snapshot.hasError){
              return Center(
                child: Icon(
                  Icons.error, 
                  size: 100, 
                  color: AppColors.red
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadData(isList: true);
            } else {
              List<CommentModel> comments = snapshot.data!;
              return ListView.builder(
                itemCount: comments.length,
                shrinkWrap: true,
                hitTestBehavior: HitTestBehavior.translucent,
                scrollDirection: Axis.vertical,
                clipBehavior: Clip.hardEdge,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) => CommentWidget(
                  comment: comments[index], 
                  id: widget.food.foodId,
                  isReply: false,
                ),
              );
            }
          }
        ),
      )
    );
  }
  Widget get commentTitle {
    return FutureBuilder<int>(
      future: getCommentCount, 
      builder: (context, snapshot){
        if (!snapshot.hasData || snapshot.hasError){
          return Text(
            "${"comment".tr()} (0)",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        } else {
          int data = snapshot.data!;
          return Text(
            "${"comment".tr()} ($data)",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800
            ),
          );
        }
      }
    );
  }
}