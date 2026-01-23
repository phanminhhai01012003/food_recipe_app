import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/routes.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  int selectedIndex = 0;
  List<Widget> pages = [rules, instructionPage];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sử dụng dịch vụ",
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
                        "Điều khoản",
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
                        "Hướng dẫn",
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