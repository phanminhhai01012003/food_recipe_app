import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/views/main/food_details/user_interaction/component/comment_selection.dart';
import 'package:intl/intl.dart';

class CommentWidget extends StatefulWidget {
  final String id;
  final bool isReply;
  final CommentModel comment;
  const CommentWidget({super.key, required this.comment, required this.id, required this.isReply});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool isLikedComment = false;
  void pushLikeCommentNotification() async{
    notificationData.pushInteractNotifications(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      title: "${currentUser.displayName} đã thích bình luận của bạn", 
      body: "Nhấn để xem", 
      from: currentUser.displayName!, 
      to: widget.comment.userName, 
      type: "Thích bình luận", 
      isRead: false, 
      createdAt: DateTime.now()
    );
  }
  void toggleComment({
    required bool isLikedComment, 
    required CollectionReference<Map<String, dynamic>> collection, 
    required String id
  }){
    if (isLikedComment) {
      collection.doc(id).update({
        "likes": FieldValue.arrayUnion([{
          "id": currentUser.uid,
          "avatar": currentUser.photoURL,
          "username": currentUser.displayName
        }]),
      });
    } else {
      collection.doc(id).update({
        "likes": FieldValue.arrayRemove([{
          "id": currentUser.uid,
          "avatar": currentUser.photoURL,
          "username": currentUser.displayName
        }]),
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLikedComment = widget.comment.likesList.any((likes) => likes['id'] == currentUser.uid);
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      surfaceTintColor: theme.colorScheme.primary,
      child: GestureDetector(
        onLongPress: () => widget.comment.userId == currentUser.uid 
          ? CommentSelection.showSelectionWithCurrentUser(context, widget.comment, widget.id, widget.isReply)
          : CommentSelection.showGeneralSelection(context, widget.comment),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.primary
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, checkDeviceRoute(personalScreen(widget.comment.userId))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: widget.comment.avatar,
                        progressIndicatorBuilder: (context, url, progress) => Center(
                          child: CircularProgressIndicator(
                            value: progress.progress,
                            color: AppColors.yellow,
                          )
                        ),
                        fit: BoxFit.cover,
                        width: 33,
                        height: 33,
                        errorWidget: (context, url, error) => Center(
                          child: Icon(
                            Icons.error,
                            size: 20,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.comment.userName,
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w900
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              DateFormat("dd/MM/yyyy").format(widget.comment.createdAt),
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700
                              ),
                            ),    
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.comment.content,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(top: 12, left: 16),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Thích ${widget.comment.likesList.isEmpty ? "" : "(${widget.comment.likesList.length})"} ",
                        recognizer: TapGestureRecognizer()..onTap = (){
                          setState(() {
                            isLikedComment = !isLikedComment;
                          });
                          toggleComment(
                            isLikedComment: isLikedComment, 
                            collection: commentCollection(widget.id), 
                            id: widget.comment.commentId
                          );
                        },
                        style: TextStyle(
                          color: isLikedComment ? AppColors.blue : theme.colorScheme.secondary,
                          fontSize: 12,
                          fontWeight: isLikedComment ? FontWeight.w700 : FontWeight.w300
                        )
                      ),
                      TextSpan(
                        text: " Trả lời",
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w300
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context, checkDeviceRoute(replyPage(widget.comment, widget.id)))
                      )
                    ]
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}