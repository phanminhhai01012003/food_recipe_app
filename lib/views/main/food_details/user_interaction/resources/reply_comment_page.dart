import 'package:cached_network_image/cached_network_image.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/services/firestore/comment/comment_services.dart';
import 'package:food_recipe_app/services/notification/notification_data.dart';
import 'package:food_recipe_app/views/main/food_details/user_interaction/component/comment_widget.dart';

class ReplyCommentPage extends StatefulWidget {
  final CommentModel comment;
  final String id;
  const ReplyCommentPage({super.key, required this.comment, required this.id});

  @override
  State<ReplyCommentPage> createState() => _ReplyCommentPageState();
}

class _ReplyCommentPageState extends State<ReplyCommentPage> {
  final commentServices = CommentServices();
  final _currentUser = FirebaseAuth.instance.currentUser!;
  final _commentController = TextEditingController();
  bool get checkComment => _commentController.text.isEmpty;
  final notificationData = NotificationData();
  void onAddReply(){
    CommentModel comment = CommentModel(
      commentId: widget.comment.commentId, 
      userId: _currentUser.uid, 
      avatar: _currentUser.photoURL!, 
      userName: _currentUser.displayName!, 
      content: _commentController.text, 
      likesList: [], 
      replies: [], 
      createdAt: DateTime.now()
    );
    commentServices.addReplyComment(context, comment, widget.id);
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
        title: Text("Trả lời bình luận",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            commentComponent(widget.comment),
            CommentBox(
              userImage: CommentBox.commentImageParser(imageURLorPath: _currentUser.displayName),
              labelText: "Viết bình luận",
              errorText: "Không được để trống bình luận",
              withBorder: true,
              sendButtonMethod: () {
                if (formKey.currentState!.validate()){
                  onAddReply();
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
              child: ListView.builder(
                itemCount: widget.comment.replies.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                hitTestBehavior: HitTestBehavior.translucent,
                clipBehavior: Clip.hardEdge,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) => CommentWidget(
                  comment: widget.comment.replies[index], 
                  id: widget.id
                ),
              )
            ),
          ],
        ),
      )
    );
  }
  Widget commentComponent(CommentModel comment){
    return Container(
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12)
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: comment.avatar,
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: CircularProgressIndicator(
                value: progress.progress,
                color: AppColors.yellow,
              )
            ),
            fit: BoxFit.cover,
            width: 33,
            height: 33,
            errorWidget: (context, url, error) => Image.asset(userDefaultImage),
          ),
          SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.userName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.comment.content,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}