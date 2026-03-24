import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/constants/list_constants.dart';
import 'package:food_recipe_app/common/extension/datetime_extension.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/convert.dart';
import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/model/save_food_model.dart';
import 'package:food_recipe_app/provider/save_state.dart';
import 'package:food_recipe_app/services/notification/notification_service.dart';
import 'package:food_recipe_app/views/main/food_details/user_interaction/resources/like_list_modal.dart';
import 'package:food_recipe_app/widget/full_screen_image/show_image_sheet.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_report_modal.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class FoodDetailPage extends StatefulWidget {
  final FoodModel food;
  const FoodDetailPage({super.key, required this.food});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  bool isLikedPost = false;
  bool isSaved = false;
  late VideoPlayerController _playerController;
  ChewieController? _chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLikedPost = widget.food.likes.any((likes) => likes['id'] == currentUser.uid);
    isSaved = context.read<SaveState>().foodProducts.any((e) => e.foods == widget.food);
    initVideo();
  }
  void toggleLikePost(){
    setState(() {
      isLikedPost = !isLikedPost;
    });
    if (isLikedPost) {
      foodCollection.doc(widget.food.foodId).update({
        "likes": FieldValue.arrayUnion([{
          "id": currentUser.uid,
          "avatar": currentUser.photoURL,
          "username": currentUser.displayName
        }])
      });
      // pushLikesNotifications();
    } else {
      foodCollection.doc(widget.food.foodId).update({
        "likes": FieldValue.arrayRemove([{
          "id": currentUser.uid,
          "avatar": currentUser.photoURL,
          "username": currentUser.displayName
        }])
      });
    }
  }
  Future<void> initVideo() async{
    _playerController = VideoPlayerController.networkUrl(Uri.parse(widget.food.image));
    await _playerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _playerController,
      deviceOrientationsAfterFullScreen: orientations,
      deviceOrientationsOnEnterFullScreen: orientations,
      aspectRatio: _playerController.value.aspectRatio
    );
    setState(() {});
  }
  Future<List<Map<String, dynamic>>> fetchLikeList() async{
    final doc = await foodCollection.doc(widget.food.foodId).get();
    List<Map<String, dynamic>> likes = List<Map<String, dynamic>>.from(doc['likes']);
    return likes;
  }
  void pushLikesNotifications(){
    NotificationService.showNotification(
      title: widget.food.title, 
      body: "${currentUser.displayName} đã thích bài viết của bạn", 
      payload: widget.food.avatar
    );
    notificationData.pushInteractNotifications(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      title: widget.food.title, 
      body: "${currentUser.displayName} đã thích bài viết của bạn", 
      from: currentUser.displayName ?? "", 
      to: widget.food.userName,
      mainData: widget.food.toMap(),
      extraData: {},
      type: "Thích bài viết", 
      isRead: false, 
      createdAt: DateTime.now()
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _playerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SaveFoodModel save = SaveFoodModel(
      saveId: generateRandomString(24), 
      userId: currentUser.uid, 
      isSaved: true, 
      foods: widget.food
    );
    bool isImage = widget.food.image.contains("jpg") || widget.food.image.contains("jpeg") || widget.food.image.contains("png");
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () async => await showImageChoiceBottomSheet(context, widget.food.image),
                  child: Hero(
                    tag: widget.food.image,
                    child: Builder(
                      builder: (context) {
                        if (isImage) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.food.image),
                                fit: BoxFit.cover
                              )
                            ),
                          );
                        } else {
                          if (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized) {
                            return Chewie(controller: _chewieController!);
                          }                          
                          return CircularProgressIndicator(color: AppColors.yellow);
                        }
                      },
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
                            Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                            size: 20,
                            color: AppColors.white,
                          )
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle
                        ),
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () async{
                            await showReportModal(context, "${"food".tr()} ${widget.food.title}", widget.food.userName, null);
                          },
                          icon: Icon(
                            Icons.warning_sharp,
                            size: 20,
                            color: AppColors.white,
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: widget.food.isAI,
                    child: Text(
                      "fileByAI".tr(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.secondary
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.food.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${"categories".tr()}: ${widget.food.tag.tr()}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "created".tr(widget.food.createdAt.ddmmyyyy),
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      SizedBox(width: 50),
                      Text(
                        "views".tr(widget.food.views.toString()),
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () => Navigator.push(context, checkDeviceRoute(personalScreen(widget.food.userId))),
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
                            errorWidget: (context, url, error) => Icon(Icons.error, size: 20),
                          )
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.food.userName,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("${"foodDesc".tr()}:",
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
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
                        "${widget.food.diet} ${"people".tr()}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.secondary
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
                          color: theme.colorScheme.secondary
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${"ingredientsInput".tr()}:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  ),
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
                                color: theme.colorScheme.secondary
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.food.ingredients[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: theme.colorScheme.secondary
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    "steps2".tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  ),
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
                              "step".tr("${index + 1}"),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: theme.colorScheme.secondary
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.food.steps[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: theme.colorScheme.secondary
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
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
                            GestureDetector(
                              onTap: () async{
                                await showLikesListModal(context, fetchLikeList(), widget.food.likes.length);
                              },
                              child: Text(
                                widget.food.likes.length.toString(),
                                style: TextStyle(
                                  color: theme.colorScheme.secondary,
                                  fontSize: 16
                                ),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isSaved = !isSaved;
                            });
                            if (isSaved){
                              context.read<SaveState>().toggleAdd(save);
                            } else {
                              context.read<SaveState>().toggleRemove(save);
                            }
                          },
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? AppColors.yellow : AppColors.grey,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment, size: 20),
                          SizedBox(width: 5),
                          Text(
                            "comment".tr(),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add, 
                            size: 20
                          ),
                          SizedBox(width: 5),
                          Text(
                            "cookbook".tr(),
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