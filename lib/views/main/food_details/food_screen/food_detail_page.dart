import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/convert.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/model/save_food_model.dart';
import 'package:food_recipe_app/provider/save_state.dart';
import 'package:food_recipe_app/services/notification/notification_data.dart';
import 'package:food_recipe_app/views/main/food_details/user_interaction/resources/like_list_modal.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_report_modal.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class FoodDetailPage extends StatefulWidget {
  final FoodModel food;
  final String id;
  final List<Map<String, dynamic>> likedList;
  const FoodDetailPage({
    super.key, 
    required this.food,
    required this.id,
    required this.likedList
  });

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  final noficationData = NotificationData();
  final foodCollection = FirebaseFirestore.instance.collection("food_recipe");
  bool isLikedPost = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLikedPost = widget.likedList.any((likes) => likes['id'] == _currentUser.uid);
  }
  void toggleLikePost(){
    setState(() {
      isLikedPost = !isLikedPost;
    });
    if (isLikedPost) {
      foodCollection.doc(widget.id).update({
        "likes": FieldValue.arrayUnion([{
          "id": _currentUser.uid,
          "avatar": _currentUser.photoURL,
          "username": _currentUser.displayName
        }])
      });
      // pushLikesNotifications();
    } else {
      foodCollection.doc(widget.id).update({
        "likes": FieldValue.arrayRemove([{
          "id": _currentUser.uid,
          "avatar": _currentUser.photoURL,
          "username": _currentUser.displayName
        }])
      });
    }
  }
  Future<List<Map<String, dynamic>>> fetchLikeList() async{
    final doc = await foodCollection.doc(widget.id).get();
    List<Map<String, dynamic>> likes = List<Map<String, dynamic>>.from(doc['likes']);
    return likes;
  }
  void pushLikesNotifications(){
    noficationData.pushInteractNotifications(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      title: "${_currentUser.displayName} đã thích bài viết của bạn", 
      body: "Nhấn để xem", 
      from: _currentUser.displayName!, 
      to: widget.food.userName, 
      type: "Thích bài viết", 
      isRead: false, 
      createdAt: DateTime.now()
    );
  }
  @override
  Widget build(BuildContext context) {
    SaveFoodModel save = SaveFoodModel(
      saveId: generateRandomString(19), 
      userId: _currentUser.uid, 
      isSaved: true, 
      foods: widget.food
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                FullScreenWidget(
                  disposeLevel: DisposeLevel.Medium,
                  child: Hero(
                    tag: widget.food.image,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.food.image),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle
                        ),
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context), 
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                            color: AppColors.white,
                          )
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            shape: BoxShape.circle
                        ),
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () async{
                            await showReportModal(context, "Món ${widget.food.title}", widget.food.userName, null);
                          },
                          icon: Icon(
                            Icons.warning_sharp,
                            size: 20,
                            color: Colors.white,
                          )
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.food.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Thể loại: ${widget.food.tag}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Đã tạo: ${DateFormat("dd/MM/yyyy").format((widget.food.createdAt))}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () => Navigator.push(context, checkDeviceRoute(personalScreen(widget.food.foodId))),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: widget.food.avatar,
                            fit: BoxFit.cover,
                            width: 30,
                            height: 30,
                            progressIndicatorBuilder: (context, url, progress) => Center(
                              child: CircularProgressIndicator(
                                value: progress.progress,
                                color: AppColors.yellow,
                              )
                            ),
                            errorWidget: (context, url, error) => Image.asset(userDefaultImage),
                          )
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.food.userName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Mô tả:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.food.description,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person_2,
                        size: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "${widget.food.diet} người",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black
                        ),
                      ),
                      SizedBox(width: 50),
                      Icon(
                        Icons.timer_rounded,
                        size: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.food.duration,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Nguyên liệu:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    itemCount: widget.food.ingredients.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}. ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.food.ingredients[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Các bước thực hiện:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    itemCount: widget.food.steps.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bước ${index + 1}: ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.food.steps[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: toggleLikePost, 
                              icon: Icon(
                                isLikedPost ? Icons.favorite : Icons.favorite_border,
                                color: isLikedPost ? AppColors.red : AppColors.grey,
                                size: 20,
                              )
                            ),
                            SizedBox(width: 5),
                            GestureDetector(
                              onTap: () async{
                                await showLikesListModal(context, fetchLikeList());
                              },
                              child: Text(
                                widget.likedList.length.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                                ),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => context.read<SaveState>().toggle(save),
                          icon: Icon(
                            context.read<SaveState>().isExist(save) ? Icons.bookmark : Icons.bookmark_border,
                            color: context.read<SaveState>().isExist(save) ? AppColors.yellow : AppColors.grey,
                            size: 20,
                          )
                        ),
                        IconButton(
                          onPressed: () => Share.share(widget.food.title), 
                          icon: Icon(
                            Icons.share, 
                            size: 20, 
                            color: AppColors.grey
                          )
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.white,
                        shape: StadiumBorder()
                      ),
                      onPressed: () => Navigator.push(context, checkDeviceRoute(commentPage(widget.food))), 
                      child: Row(
                        children: [
                          Icon(Icons.comment, size: 20),
                          SizedBox(width: 5),
                          Text(
                            "Bình luận",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        foregroundColor: AppColors.white,
                        shape: StadiumBorder()
                      ),
                      onPressed: () {
                        Navigator.push(context, checkDeviceRoute(cookbookSelection(widget.food)));
                      }, 
                      child: Row(
                        children: [
                          Icon(
                            Icons.add, 
                            size: 20
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Nhật ký",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700
                            ),
                          )
                        ],
                      )
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}