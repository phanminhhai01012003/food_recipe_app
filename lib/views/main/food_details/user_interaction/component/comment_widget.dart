import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final CommentModel comment;
  const CommentWidget({super.key, required this.comment, required this.id});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  bool isLikedComment = false;
  void toggleComment({
    required bool isLikedComment, 
    required CollectionReference<Map<String, dynamic>> collection, 
    required String id
  }){
    if (isLikedComment) {
      collection.doc(id).update({
        "likes": FieldValue.arrayUnion([{
          "id": _currentUser.uid,
          "avatar": _currentUser.photoURL,
          "username": _currentUser.displayName
        }]),
      });
    } else {
      collection.doc(id).update({
        "likes": FieldValue.arrayRemove([{
          "id": _currentUser.uid,
          "avatar": _currentUser.photoURL,
          "username": _currentUser.displayName
        }]),
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLikedComment = widget.comment.likesList.any((likes) => likes['id'] == _currentUser.uid);
  }
  @override
  Widget build(BuildContext context) {
    final commentCollection = FirebaseFirestore.instance
      .collection("food_recipe")
      .doc(widget.id)
      .collection("comment");
    return Card(
      surfaceTintColor: AppColors.white,
      child: GestureDetector(
        onLongPress: () => widget.comment.userId == _currentUser.uid 
          ? CommentSelection.showSelectionWithCurrentUser(context, widget.comment, widget.id)
          : CommentSelection.showGeneralSelection(context, widget.comment),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, checkDeviceRoute(personalScreen(widget.comment.userId))),
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
                      errorWidget: (context, url, error) => Image.asset(userDefaultImage),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.comment.userName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900
                            ),
                          ),
                          SizedBox(width: 3),
                          Text(
                            DateFormat("dd/MM/yyyy").format(widget.comment.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700
                            ),
                          ),    
                        ],
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: Text(
                          widget.comment.content,
                            style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Thích ${widget.comment.likesList.isEmpty ? "" : "(${widget.comment.likesList.length})"}",
                        recognizer: TapGestureRecognizer()..onTap = (){
                          setState(() {
                            isLikedComment = !isLikedComment;
                          });
                          toggleComment(
                            isLikedComment: isLikedComment, 
                            collection: commentCollection, 
                            id: widget.comment.commentId
                          );
                        },
                        style: TextStyle(
                          color: isLikedComment ? AppColors.blue : AppColors.grey,
                          fontSize: 12,
                          fontWeight: isLikedComment ? FontWeight.w700 : FontWeight.w300
                        )
                      ),
                      TextSpan(
                        text: "Trả lời",
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