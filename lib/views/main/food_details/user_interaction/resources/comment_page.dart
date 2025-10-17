import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/convert.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/services/firestore/comment/comment_services.dart';
import 'package:food_recipe_app/services/notification/notification_data.dart';
import 'package:food_recipe_app/views/main/food_details/user_interaction/component/comment_widget.dart';
import 'package:food_recipe_app/widget/other/load_data.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class CommentPage extends StatefulWidget {
  final FoodModel food;
  const CommentPage({super.key, required this.food});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final commentServices = CommentServices();
  final _currentUser = FirebaseAuth.instance.currentUser!;
  final _commentController = TextEditingController();
  bool get checkComment => _commentController.text.isEmpty;
  final notificationData = NotificationData();
  void onAddComment() async{
    CommentModel comment = CommentModel(
      commentId: generateRandomString(18),
      userId: _currentUser.uid,
      avatar: _currentUser.photoURL!, 
      userName: _currentUser.displayName!, 
      content: _commentController.text,
      likesList: [],
      replies: [],
      createdAt: DateTime.now()
    );
    await commentServices.addComment(context, comment, widget.food.foodId).then((_) async{
      Message.showScaffoldMessage(context, "Đã gửi bình luận", AppColors.green);
      // pushCommentNotifications();
    });
  }
  void pushCommentNotifications(){
    notificationData.pushInteractNotifications(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      title: "${_currentUser.displayName} đã thích bài viết của bạn", 
      body: "Nhấn để xem", 
      from: _currentUser.displayName!, 
      to: widget.food.userName, 
      type: "Bình luận bài viết", 
      isRead: false, 
      createdAt: DateTime.now()
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(Icons.arrow_back, size: 25)
          ),
        ),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        title: Text("Bình luận",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800
          ),
        ),
        centerTitle: true,
      ),
      body: CommentBox(
        userImage: CommentBox.commentImageParser(imageURLorPath: _currentUser.displayName),
        labelText: "Viết bình luận",
        errorText: "Không được để trống bình luận",
        withBorder: true,
        sendButtonMethod: () {
          if (formKey.currentState!.validate()){
            onAddComment();
            _commentController.clear();
            FocusScope.of(context).unfocus();
          }
        },
        commentController: _commentController,
        backgroundColor: AppColors.green,
        textColor: AppColors.white,
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
                  id: widget.food.foodId
                ),
              );
            }
          }
        ),
      )
    );
  }
}