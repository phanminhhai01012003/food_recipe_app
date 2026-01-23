import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/routes.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Giới thiệu",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
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
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: selectedIndex == 0 ? AppColors.green : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(33),
                    ),
                    child: Center(
                      child: Text(
                        "Tổng quan",
                        style: TextStyle(
                          color: selectedIndex == 0 ? AppColors.white : theme.colorScheme.secondary,
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
                    height: 50,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: selectedIndex == 1 ? AppColors.green : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(33),
                    ),
                    child: Center(
                      child: Text(
                        "Liên hệ",
                        style: TextStyle(
                          color: selectedIndex == 1 ? AppColors.white : theme.colorScheme.secondary,
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