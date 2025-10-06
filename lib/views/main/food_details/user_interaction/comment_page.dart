import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/convert.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/services/firestore/comment/comment_services.dart';
import 'package:food_recipe_app/views/main/food_details/user_interaction/component/comment_widget.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class CommentPage extends StatefulWidget {
  final FoodModel food;
  const CommentPage({super.key, required this.food});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  final _commentController = TextEditingController();
  bool get checkComment => _commentController.text.isEmpty;
  void onAddComment(CommentServices commentServices) async{
    CommentModel comment = CommentModel(
      commentId: generateRandomString(20),
      userId: _currentUser.uid,
      avatar: _currentUser.photoURL!, 
      userName: _currentUser.displayName!, 
      content: _commentController.text,
      likesList: [],
      replies: [],
      createdAt: DateTime.now()
    );
    await commentServices.addComment(context, comment).then((_){
      Message.showScaffoldMessage(context, "Đã gửi bình luận", AppColors.green);
    });
  }
  @override
  Widget build(BuildContext context) {
    final commentServices = CommentServices(foodId: widget.food.foodId);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        title: Text("Bình luận"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: _commentController,
            cursorColor: AppColors.blue,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700
            ),
            decoration: InputDecoration(
              prefixIcon: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: Icon(Icons.comment, color: AppColors.grey),
              ),
              hintText: "Viết bình luận",
              hintStyle: TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700
              ),
              suffixIcon: IconButton(
                onPressed: () => onAddComment(commentServices), 
                icon: Icon(Icons.send, color: AppColors.grey, size: 20)
              )
            ),
          ),
          SizedBox(height: 50),
          StreamBuilder(
            stream: commentServices.getComment(context), 
            builder: (context, snapshot){
              if (!snapshot.hasData || snapshot.hasError) {
                return Center(child: Icon(Icons.error, size: 100, color: AppColors.red));
              } else if (snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              } else {
                List<CommentModel> data = snapshot.data!;
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(color: AppColors.grey, height: 0, thickness: 1),
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) => CommentWidget(
                    comment: data[index], 
                    id: widget.food.foodId,
                  ),
                );
              }
            }
          )
        ],
      ),
    );
  }
}