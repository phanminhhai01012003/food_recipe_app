import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/data/enum.dart';

class StorageModeSelect extends StatefulWidget {
  const StorageModeSelect({super.key});

  @override
  State<StorageModeSelect> createState() => _StorageModeSelectState();
}

class _StorageModeSelectState extends State<StorageModeSelect> {
  void onSelect(StorageMode storage){
    switch(storage) {
      case StorageMode.myFood:
        Navigator.push(context, checkDeviceRoute(myFoodScreen));
      case StorageMode.saveFood:
        Navigator.push(context, checkDeviceRoute(saveFoodScreen));
      case StorageMode.recentView:
        Navigator.push(context, checkDeviceRoute(recentScreen));
      case StorageMode.cookbook:
        Navigator.push(context, checkDeviceRoute(cookbookPage));
    }
  }
  Color getColor(StorageMode storage) {
    switch(storage) {
      case StorageMode.myFood:
        return AppColors.blue;
      case StorageMode.saveFood:
        return AppColors.green;
      case StorageMode.recentView:
        return AppColors.red;
      case StorageMode.cookbook:
        return AppColors.yellow;
    }
  }
  String renderTitle(StorageMode storage) {
    switch(storage) {
      case StorageMode.myFood:
        return "Món ăn của tôi";
      case StorageMode.saveFood:
        return "Món ăn đã lưu";
      case StorageMode.recentView:
        return "Đã xem gần đây";
      case StorageMode.cookbook:
        return "Sổ tay nấu ăn";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        centerTitle: true,
        title: Text("Lưu trữ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            modeButton(
              color: getColor(StorageMode.myFood), 
              onPressed: () => onSelect(StorageMode.myFood), 
              title: renderTitle(StorageMode.myFood)
            ),
            SizedBox(height: 20),
            modeButton(
              color: getColor(StorageMode.saveFood), 
              onPressed: () => onSelect(StorageMode.saveFood), 
              title: renderTitle(StorageMode.saveFood)
            ),
            SizedBox(height: 20),
            modeButton(
              color: getColor(StorageMode.recentView), 
              onPressed: () => onSelect(StorageMode.recentView), 
              title: renderTitle(StorageMode.recentView)
            ),
            SizedBox(height: 20),
            modeButton(
              color: getColor(StorageMode.cookbook), 
              onPressed: () => onSelect(StorageMode.cookbook), 
              title: renderTitle(StorageMode.cookbook)
            ),
          ],
        ),
      ),
    );
  }
  Widget modeButton({
    required Color color,
    required VoidCallback onPressed,
    required String title
  }){
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white
        ),
        onPressed: onPressed, 
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal
          ),
        )
      ),
    );
  }
}