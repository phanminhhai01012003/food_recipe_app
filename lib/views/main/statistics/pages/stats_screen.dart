import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/views/main/statistics/pages/general_statistics.dart';
import 'package:food_recipe_app/views/main/statistics/pages/preliminary_statistics.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with TickerProviderStateMixin{
  late TabController _tabController; 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2, 
      vsync: this
    );
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, 
              size: 20
            )
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        title: Text("stats".tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              unselectedLabelColor: theme.colorScheme.secondary,
              dividerColor: theme.colorScheme.secondary,
              labelColor: AppColors.green,
              indicatorColor: AppColors.green,
              padding: EdgeInsets.all(12),
              tabs: [
                Text(
                  "stats".tr(),
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "localStats".tr(),
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  GeneralStatistics(),
                  PreliminaryStatistics()
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}