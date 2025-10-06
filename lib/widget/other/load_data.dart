import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class LoadData extends StatelessWidget {
  final bool isList;
  const LoadData({super.key, required this.isList});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey,
      highlightColor: AppColors.grey,
      child: isList ? ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => loadingListCard
      ) : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8
        ),
        itemCount: 5,
        itemBuilder: (context, index) => loadingGridCard
      ),
    );
  }
  Widget get loadingListCard {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            color: AppColors.white,
            width: 50,
            height: 50,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10,
                  color: AppColors.white,
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 10,
                  color: AppColors.white,
                  margin: EdgeInsets.only(right: 50),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget get loadingGridCard {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            color: AppColors.white,
            width: 50,
            height: 50,
          ),
          SizedBox(height: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10,
                  color: AppColors.white,
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 10,
                  color: AppColors.white,
                  margin: EdgeInsets.only(right: 50),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}