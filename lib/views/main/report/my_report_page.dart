import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/report_model.dart';
import 'package:food_recipe_app/services/firestore/report/report_services.dart';
import 'package:food_recipe_app/widget/other/load_data.dart';

class MyReportPage extends StatefulWidget {
  const MyReportPage({super.key});

  @override
  State<MyReportPage> createState() => _MyReportPageState();
}

class _MyReportPageState extends State<MyReportPage> {
  int statusIndex = 0;
  final report = ReportServices();
  final currentUser = FirebaseAuth.instance.currentUser!;
  String renderStatus(int status){
    switch (status) {
      case 0:
        return "Chờ duyệt";
      case 1:
        return "Đã đồng ý";
      case 2:
        return "Đã từ chối";
      default:
        return "Không xác định";
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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        centerTitle: true,
        title: Text("Danh sách báo cáo/chặn",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
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
                      color: statusIndex == 0 ? AppColors.green : AppColors.white,
                      borderRadius: BorderRadius.circular(33)
                    ),
                    child: Center(
                      child: Text(
                        "Chờ duyệt",
                        style: TextStyle(
                          color: statusIndex == 0 ? AppColors.white : AppColors.black,
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
                      color: statusIndex == 1 ? AppColors.green : AppColors.white,
                      borderRadius: BorderRadius.circular(33)
                    ),
                    child: Center(
                      child: Text(
                        "Đã duyệt",
                        style: TextStyle(
                          color: statusIndex == 1 ? AppColors.white : AppColors.black,
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
                      color: statusIndex == 2 ? AppColors.green : AppColors.white,
                      borderRadius: BorderRadius.circular(33)
                    ),
                    child: Center(
                      child: Text(
                        "Từ chối",
                        style: TextStyle(
                          color: statusIndex == 2 ? AppColors.white : AppColors.black,
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
              stream: report.getReportList(context, currentUser.displayName!, statusIndex), 
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
                      onLongPress: () async{},
                      child: Card(
                        surfaceTintColor: AppColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: AppColors.white,
                        child: Column(
                          children: [
                            Expanded(
                              child: Text(
                                "Tiêu đề: ${reports[index].target}",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Text(
                                "Nội dung: ${reports[index].reason}",
                                style: TextStyle(
                                  color: AppColors.black,
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
                                    text: "Trạng thái",
                                    style: TextStyle(
                                      color: AppColors.black,
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