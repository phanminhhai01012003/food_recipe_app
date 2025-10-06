import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/report_model.dart';
import 'package:food_recipe_app/services/firestore/report/report_services.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_report_modal.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/message.dart';

Future showReportSelectionModal(BuildContext context, ReportModel report) async{
  return await showModalBottomSheet(
    context: context,
    // ignore: deprecated_member_use
    barrierColor: AppColors.black.withOpacity(0.5),
    isScrollControlled: true,
    builder: (context) => ReportSelection(report: report)
  );
}

class ReportSelection extends StatefulWidget {
  final ReportModel report;
  const ReportSelection({super.key, required this.report});

  @override
  State<ReportSelection> createState() => _ReportSelectionState();
}

class _ReportSelectionState extends State<ReportSelection> {
  final reportServices = ReportServices();
  void onDelete(String id) async{
    await reportServices.deleteReport(context, id).then((_){
      Message.showScaffoldMessage(context, "Đã xóa", AppColors.green);
      Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        color: AppColors.white
      ),
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.only(bottom: 15, left: 20, right: 20),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16, top: 10),
            decoration: ShapeDecoration(
              shape: StadiumBorder(),
              color: AppColors.grey
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async{
                      if (widget.report.status != 0) {
                        Message.showToast("Bạn không có quyền sửa thông tin do quản trị viên đã duyệt");
                      }
                      await showReportModal(context, widget.report.target, widget.report.author, widget.report);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.yellow
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Sửa",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.normal
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.report.status != 0) {
                        onDelete(widget.report.reportId);
                      }
                      ShowYesnoDialog.checkDeviceDialog(
                        context, 
                        title: "Xóa báo cáo", 
                        content: "Quản trị viên chưa duyệt, bạn muốn xóa không?", 
                        onAcceptTap: () => onDelete(widget.report.reportId), 
                        onCancelTap: () => Navigator.pop(context)
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.red
                      ),
                      child: Icon(
                        Icons.delete,
                        size: 20,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Xóa",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.normal
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}