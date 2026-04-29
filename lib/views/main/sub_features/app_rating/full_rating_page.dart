import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/list_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/model/rating_model.dart';
import 'package:food_recipe_app/views/main/sub_features/app_rating/rate_component.dart';
import 'package:food_recipe_app/widget/load_data/load_data.dart';

class FullRatingPage extends StatefulWidget {
  const FullRatingPage({super.key});

  @override
  State<FullRatingPage> createState() => _FullRatingPageState();
}

class _FullRatingPageState extends State<FullRatingPage> {
  String? selectedFilterRate;
  Stream<List<RatingModel>> getRatingData(){
    switch(selectedFilterRate){
      case "popular":
        return rateServices.getRating(context);
      case "latest":
        return rateServices.getRatingByDate(context, true);
      case "oldest":
        return rateServices.getRatingByDate(context, false);
      default:
        return Stream.empty();
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              size: 20,
            )
          ),
        ),
        title: Text(
          "rateApp".tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, checkDeviceRoute(ratingScreen(null))), 
            icon: Icon(
              Icons.add,
              size: 20,
            )
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              "rateAttention".tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.secondary
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.secondary)
              ),
              child: DropdownButton(
                underline: SizedBox(),
                isExpanded: true,
                hint: Text("filterData".tr(),
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.normal
                  ),
                ),
                items: filterRating.map((String item){
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item.tr(),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value){
                  setState(() {
                    selectedFilterRate = value;
                  });
                },
                value: selectedFilterRate,
                icon: Icon(Icons.keyboard_arrow_down),
                iconSize: 20,
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            StreamBuilder(
              stream: getRatingData(), 
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.hasError) {
                  return SizedBox.shrink();
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadData(isList: true);
                } else {
                  List<RatingModel> ratingData = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    clipBehavior: Clip.hardEdge,
                    hitTestBehavior: HitTestBehavior.translucent,
                    physics: ClampingScrollPhysics(),
                    itemCount: ratingData.length,
                    itemBuilder: (context, index) => RateComponent(rate: ratingData[index]),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}