import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/list_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/utils/routes.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home),
            label: "home".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded),
            activeIcon: Icon(Icons.category_rounded),
            label: "categories".tr()
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            activeIcon: Icon(Icons.storage),
            label: "storage".tr()
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person),
            label: "profile".tr()
          )
        ],
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        iconSize: 20,
        selectedItemColor: AppColors.green,
        selectedFontSize: 14,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
        unselectedItemColor: AppColors.grey,
        unselectedFontSize: 14,
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
      body: pages[selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, checkDeviceRoute(addFood)),
        shape: CircleBorder(),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        child: Icon(Icons.add, size: 25),
      ),
    );
  }
}