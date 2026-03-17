import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/follow_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/model/recent_view_model.dart';
import 'package:food_recipe_app/model/save_food_model.dart';
import 'package:food_recipe_app/provider/history_state.dart';
import 'package:food_recipe_app/provider/save_state.dart';
import 'package:food_recipe_app/views/main/statistics/widget/stats_container.dart';
import 'package:provider/provider.dart';

class GeneralStatistics extends StatefulWidget {
  const GeneralStatistics({super.key});

  @override
  State<GeneralStatistics> createState() => _GeneralStatisticsState();
}

class _GeneralStatisticsState extends State<GeneralStatistics> {
  Future<int> get foodAmount async{
    final snapshot = await foodCollection
      .where("userId", isEqualTo: currentUser.uid)
      .count()
      .get();
    return snapshot.count!;
  }
  Future<int> get commentCount async{
    final snapshot = await foodCollection
      .where("userId", isEqualTo: currentUser.uid)
      .get()
      .then((value) => value.docs.map((e) => FoodModel.fromMap(e.data())));
    int total = 0;
    for (var ss in snapshot) {
      final data = await commentCollection(ss.foodId).count().get();
      total = data.count!;
    }
    return total;
  }
  Future<int> get numberOfLikes async{
    final snapshot = await foodCollection
      .where("userId", isEqualTo: currentUser.uid)
      .get()
      .then((value) => value.docs.map((e) => FoodModel.fromMap(e.data())));
    int total = 0;
    for (var ss in snapshot) {
      total += ss.likes.length;
    }
    return total;
  }
  Future<int> get numberOfViews async{
    final snapshot = await foodCollection
      .where("userId", isEqualTo: currentUser.uid)
      .get()
      .then((value) => value.docs.map((e) => FoodModel.fromMap(e.data())));
    int total = 0;
    for (var ss in snapshot) {
      total += ss.views;
    }
    return total;
  }
  Future<int> get getNumberOfFollowing async{
    final data = await followCollection(currentUser.uid)
      .doc(currentUser.uid)
      .get()
      .then((value) => FollowModel.fromMap(value.data() ?? {}));
    return data.followingUser.length;
  }
  Future<int> get getNumberOfFollowed async{
    final data = await followCollection(currentUser.uid)
      .doc(currentUser.uid)
      .get()
      .then((value) => FollowModel.fromMap(value.data() ?? {}));
    return data.followedUser.length;
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatsContainer(
              title: "foodAmount".tr(), 
              data: FutureBuilder(
                future: foodAmount, 
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return Text("0",
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(color: AppColors.yellow);
                  } else {
                      int data = snapshot.data!;
                      return Text(
                        data.toString(),
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                      );
                    }
                  }
                )
              ),
              StatsContainer(
                title: "saveAmount".tr(), 
                data: Selector<SaveState, List<SaveFoodModel>>(
                  selector: (context, state) => state.foodProducts,
                  shouldRebuild: (previous, next) => true,
                  builder: (context, value, child) {
                    return Text(
                      value.length.toString(),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )
                    );
                  },
                )
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsContainer(
                title: "recentAmount".tr(), 
                data: Selector<HistoryState, List<RecentViewModel>>(
                  selector: (context, state) => state.viewProducts,
                  shouldRebuild: (previous, next) => true,
                  builder: (context, value, child) {
                    return Text(
                      value.length.toString(),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )
                    );
                  },
                )
              ),
              StatsContainer(
                title: "foodViewCount".tr(), 
                data: FutureBuilder(
                  future: numberOfViews, 
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.hasError) {
                      return Text("0",
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(color: AppColors.yellow);
                    } else {
                      int data = snapshot.data!;
                      return Text(
                        data.toString(),
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                      );
                    }
                  }
                )
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsContainer(
                title: "numberOfLikes".tr(), 
                data: FutureBuilder(
                  future: numberOfLikes, 
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.hasError) {
                      return Text("0",
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(color: AppColors.yellow);
                    } else {
                      int data = snapshot.data!;
                      return Text(
                        data.toString(),
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                      );
                    }
                  }
                )
              ),
              StatsContainer(
                title: "commentCount".tr(), 
                data: FutureBuilder(
                  future: commentCount, 
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.hasError) {
                      return Text("0",
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(color: AppColors.yellow);
                    } else {
                      int data = snapshot.data!;
                      return Text(
                        data.toString(),
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                      );
                    }
                  }
                )
              ),
          ],         
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatsContainer(
              title: "followingAmount".tr(), 
              data: FutureBuilder(
                future: getNumberOfFollowing, 
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return Text("0",
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(color: AppColors.yellow);
                  } else {
                    int data = snapshot.data!;
                    return Text(
                      data.toString(),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )
                    );
                  }
                }
              )
            ),
            StatsContainer(
              title: "followedAmount".tr(), 
              data: FutureBuilder(
                future: getNumberOfFollowed, 
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return Text("0",
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(color: AppColors.yellow);
                  } else {
                    int data = snapshot.data!;
                    return Text(
                      data.toString(),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )
                    );
                  }
                }
              )
            ),
          ],
        )
      ],
    );
  }
}