import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/routes.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  List<Widget> pages = [homeScreen, categoriesPage, foodStorageView, settings];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded),
            activeIcon: Icon(Icons.category_rounded),
            label: "Thể loại"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            activeIcon: Icon(Icons.storage),
            label: "Lưu trữ"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            activeIcon: Icon(Icons.settings),
            label: "Cài đặt"
          )
        ],
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        iconSize: 25,
        selectedItemColor: AppColors.green,
        selectedFontSize: 16,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
        unselectedItemColor: AppColors.grey,
        unselectedFontSize: 16,
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
      body: pages[selectedIndex],
    );
  }
}