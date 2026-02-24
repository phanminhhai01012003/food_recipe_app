import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/follow_model.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/widget/bottom_sheet/follow_list_modal.dart';

class GetFollowData extends StatefulWidget {
  final UserModel user;
  const GetFollowData({super.key, required this.user});

  @override
  State<GetFollowData> createState() => _GetFollowDataState();
}

class _GetFollowDataState extends State<GetFollowData> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
    return StreamBuilder(
      stream: followServices.getFollowUsers(context, widget.user.userId), 
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return SizedBox();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: theme.colorScheme.secondary);
        } else {
          List<FollowModel> followData = snapshot.data!;
          return ListView.builder(
            itemCount: followData.length,
            itemBuilder: (context, index) {
              bool contains = followData[index].followingUser.contains(widget.user);
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () async => await followList(
                              context, 
                              followData[index].followedUser,
                              "listOfFollowedUsers".tr(),
                            ),
                            child: Text(
                              followData[index].followedUser.length.toString(),
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "followedUser".tr(),
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.normal
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () async => await followList(
                              context, 
                              followData[index].followingUser,
                              "listOfFollowingUsers".tr()
                            ),
                            child: Text(
                              followData[index].followingUser.length.toString(),
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "followingUser".tr(),
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.normal
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: widget.user.userId != currentUser.uid,
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: contains ? AppColors.red : AppColors.blue,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                        ),
                        onPressed: () async{
                          final currentUserModel = await userCollection
                            .doc(currentUser.uid)
                            .get()
                            .then((value) => UserModel.fromMap(value.data() ?? {}));
                          if(contains) {
                            Future.wait([
                              followServices.removeFollowingUsers(context, widget.user, currentUser.uid),
                              followServices.removeFollowedUsers(context, currentUserModel, widget.user.userId)
                            ]);
                          } else {
                            Future.wait([
                              followServices.addFollowingUsers(context, widget.user, currentUser.uid),
                              followServices.addFollowedUsers(context, currentUserModel, widget.user.userId)
                            ]);
                          }
                        }, 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              contains ? Icons.close : Icons.add,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Text(
                              contains ? "unfollow".tr() : "follow".tr(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                              ),
                            )
                          ],
                        )
                      ),
                    ),
                  )
                ],
              );
            },
          );
        }
      }
    );
  }
}