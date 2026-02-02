import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/report_model.dart';
import 'package:food_recipe_app/views/main/report/report_selection.dart';
import 'package:food_recipe_app/widget/load_data/load_data.dart';

class MyReportPage extends StatefulWidget {
  const MyReportPage({super.key});

  @override
  State<MyReportPage> createState() => _MyReportPageState();
}

class _MyReportPageState extends State<MyReportPage> {
  int statusIndex = 0;
  String renderStatus(int status){
    switch (status) {
      case 0:
        return "pending".tr();
      case 1:
        return "accept".tr();
      case 2:
        return "reject".tr();
      default:
        return "unknown".tr();
    }
  }
  Color renderColor(int status){
    switch (status) {
      case 0:
        return AppColors.yellow;
      case 1:
        return AppColors.green;
      case 2:
        return AppColors.red;
      default:
        return AppColors.black;
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
        title: Text("reportList".tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
        ),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      statusIndex = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      color: statusIndex == 0 ? AppColors.green : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(33)
                    ),
                    child: Center(
                      child: Text(
                        "pending".tr(),
                        style: TextStyle(
                          color: statusIndex == 0 ? AppColors.white : theme.colorScheme.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      statusIndex = 1;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      color: statusIndex == 1 ? AppColors.green : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(33)
                    ),
                    child: Center(
                      child: Text(
                        "accept".tr(),
                        style: TextStyle(
                          color: statusIndex == 1 ? AppColors.white : theme.colorScheme.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      statusIndex = 2;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      color: statusIndex == 2 ? AppColors.green : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(33)
                    ),
                    child: Center(
                      child: Text(
                        "reject".tr(),
                        style: TextStyle(
                          color: statusIndex == 2 ? AppColors.white : theme.colorScheme.secondary,
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
            StreamBuilder(
              stream: reportServices.getReportList(context, currentUser.displayName!, statusIndex), 
              builder: (context, snapshot){
                if (!snapshot.hasData || snapshot.hasError) {
                  return SizedBox();
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadData(isList: true);
                } else {
                  List<ReportModel> reports = snapshot.data!;
                  return ListView.builder(
                    itemCount: reports.length,
                    hitTestBehavior: HitTestBehavior.translucent,
                    clipBehavior: Clip.hardEdge,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) => GestureDetector(
                      onLongPress: () async{
                        await showReportSelectionModal(context, reports[index]);
                      },
                      child: Card(
                        surfaceTintColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: theme.colorScheme.primary,
                        child: Column(
                          children: [
                            Expanded(
                              child: Text(
                                "title".tr(reports[index].target),
                                style: TextStyle(
                                  color: theme.colorScheme.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Text(
                                "content".tr(reports[index].reason),
                                style: TextStyle(
                                  color: theme.colorScheme.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "status".tr(),
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700
                                    ),
                                  ),
                                  TextSpan(
                                    text: renderStatus(statusIndex),
                                    style: TextStyle(
                                      color: renderColor(statusIndex),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700
                                    ),
                                  )
                                ]
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
            )
          ],
        ),
      ),
    );
  }
}