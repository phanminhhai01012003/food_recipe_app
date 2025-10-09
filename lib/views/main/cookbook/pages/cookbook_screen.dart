import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/views/main/cookbook/widget/cookbook_widget.dart';
import 'package:provider/provider.dart';

class CookbookScreen extends StatefulWidget {
  const CookbookScreen({super.key});

  @override
  State<CookbookScreen> createState() => _CookbookScreenState();
}

class _CookbookScreenState extends State<CookbookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(Icons.arrow_back, size: 20)
          ),
        ),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        title: Text(
          "Sổ tay nấu ăn của bạn",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      body: Selector<CookbookState, List<CookbookModel>>(
        selector: (context, state) => state.bookProducts,
        shouldRebuild: (previous, next) => true,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error, 
                    size: 50, 
                    color: AppColors.red
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Không có dữ liệu",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal
                    ),
                  )
                ],
              ),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: value.length,
            itemBuilder: (context, index) => CookbookWidget(book: value[index])
          );      
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, checkDeviceRoute(addCookbook)),
        shape: CircleBorder(),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        child: Icon(Icons.add, size: 25),
      ),
    );
  }
}