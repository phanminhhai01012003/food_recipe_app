import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/views/main/statistics/widget/stats_container.dart';
import 'package:food_recipe_app/widget/load_data/load_data.dart';

class PreliminaryStatistics extends StatefulWidget {
  const PreliminaryStatistics({super.key});

  @override
  State<PreliminaryStatistics> createState() => _PreliminaryStatisticsState();
}

class _PreliminaryStatisticsState extends State<PreliminaryStatistics> {
  Set<FoodModel> selected = {};
  Future<int> getCommentCount(String foodId) async{
    final snapshot = await commentCollection(foodId).count().get();
    return snapshot.count!;
  }
  void onSelected(FoodModel food) {
    if (selected.contains(food)) {
      selected.remove(food);
    } else {
      selected.add(food);
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder(
      stream: foodServices.getFoodByUser(context, currentUser.uid), 
      builder: (context, snapshot){
        if (!snapshot.hasData || snapshot.hasError){
          return SizedBox.shrink();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadData(isList: true);
        } else {
          List<FoodModel> foodData = snapshot.data!;
          return ListView.builder(
            clipBehavior: Clip.hardEdge,
            hitTestBehavior: HitTestBehavior.translucent,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: foodData.length,
            itemBuilder: (context, index) => Column(
              children: [
                InkWell(
                  onTap: () => onSelected(foodData[index]),
                  child: Card(
                    elevation: 10,
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: selected.contains(foodData[index]) ? AppColors.green : theme.colorScheme.primary,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: foodData[index].image,
                            progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator(value: progress.progress)),
                            width: 50,
                            height: 50,
                            errorWidget: (context, url, error) => Image.asset(foodDesignImage),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          foodData[index].title,
                          style: TextStyle(
                            color: selected.contains(foodData[index]) ? AppColors.white : theme.colorScheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: selected.contains(foodData[index]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatsContainer(
                            title: "foodViewCount".tr(), 
                            data: Text(
                              foodData[index].views.toString(),
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ),
                          StatsContainer(
                            title: "numberOfLikes".tr(), 
                            data: Text(
                              foodData[index].likes.length.toString(),
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ),
                          StatsContainer(
                            title: "commentCount".tr(), 
                            data: FutureBuilder(
                              future: getCommentCount(foodData[index].foodId), 
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
                                    ),
                                  ); 
                                }
                              }
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      }
    );
  }
}