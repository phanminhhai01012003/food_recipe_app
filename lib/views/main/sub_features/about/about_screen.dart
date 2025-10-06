import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/routes.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int selectedIndex = 0;
  List<Widget> pages = [appoverview, contactpage];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Giới thiệu",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal
          ),
        ),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      color: selectedIndex == 0 ? AppColors.green : AppColors.white,
                      borderRadius: BorderRadius.circular(33),
                    ),
                    child: Center(
                      child: Text(
                        "Tổng quan",
                        style: TextStyle(
                          color: selectedIndex == 0 ? AppColors.white : AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedIndex == 1 ? AppColors.green : AppColors.white,
                      borderRadius: BorderRadius.circular(33),
                    ),
                    child: Center(
                      child: Text(
                        "Liên hệ",
                        style: TextStyle(
                          color: selectedIndex == 1 ? AppColors.white : AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            pages[selectedIndex]
          ],
        ),
      ),
    );
  }
}