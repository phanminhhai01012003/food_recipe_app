import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/report_model.dart';
import 'package:food_recipe_app/services/firestore/report/report_services.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';

Future<void> showReportModal(BuildContext context, String title, String author, ReportModel? reports) async{
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // ignore: deprecated_member_use
    barrierColor: AppColors.black.withOpacity(0.75),
    builder: (context) => ShowReportModal(title: title, author: author, reports: reports,)
  );
}

class ShowReportModal extends StatefulWidget {
  final String title;
  final String author;
  final ReportModel? reports;
  const ShowReportModal({super.key, required this.title, required this.author, required this.reports});

  @override
  State<ShowReportModal> createState() => _ShowReportModalState();
}

class _ShowReportModalState extends State<ShowReportModal> {
  String? selectedOption;
  bool agree = false;
  final _otherReport = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final reportServices = ReportServices();
  void onReport() async{
    if (!agree) return;
    context.loaderOverlay.show();
    ReportModel report = ReportModel(
      reportId: DateTime.now().millisecondsSinceEpoch.toString(), 
      target: widget.title,
      author: widget.author,
      reporter: currentUser.displayName!,
      reason: selectedOption == 'Khác' ? _otherReport.text : selectedOption!, 
      createdAt: DateTime.now(), 
      status: 0
    );
    await reportServices.addReport(context, report).then((_){
      context.loaderOverlay.hide();
      Message.showScaffoldMessage(
        context, 
        "Cảm ơn bạn! Kết quả duyệt sẽ được công bố trong thời gian sớm nhất", 
        AppColors.green
      );
      Navigator.pop(context);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.reports != null) {
      if (selectedOption == "Khác") {
        _otherReport.text = widget.reports!.reason;
      }
      selectedOption = widget.reports!.reason;
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _otherReport.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: EdgeInsets.only(
        bottom: max(15, MediaQuery.viewInsetsOf(context).bottom), 
        left: 20, 
        right: 20
      ),
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
          SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  "Bạn đang báo cáo/chặn ${widget.title} của ${widget.author}",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Hãy cho chúng tôi biết lý do bạn muốn báo cáo/chặn",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  ),
                ),
                SizedBox(height: 10),
                Radio<String>(
                  value: "Món ăn kém chất lượng hoặc không đảm bảo vệ sinh an toàn thực phẩm" , 
                  groupValue: selectedOption, 
                  onChanged: (value){
                    setState(() {
                      selectedOption = value;
                    });
                  }
                ),
                Radio<String>(
                  value: "Hình ảnh chứa nội dung nhạy cảm, không phù hợp (quảng cáo trá hình, khiêu dâm, kích động bạo lực, ...)", 
                  groupValue: selectedOption, 
                  onChanged: (value){
                    setState(() {
                      selectedOption = value;
                    });
                  }
                ),
                Radio<String>(
                  value: "Sử dụng từ ngữ thô tục, xúc phạm danh dự của người khác", 
                  groupValue: selectedOption, 
                  onChanged: (value){
                    setState(() {
                      selectedOption = value;
                    });
                  }
                ),
                Radio<String>(
                  value: "Nội dung đăng tải giả mạo, không đúng sự thật", 
                  groupValue: selectedOption, 
                  onChanged: (value){
                    setState(() {
                      selectedOption = value;
                    });
                  }
                ),
                Radio<String>(
                  value: "Khác (vui lòng ghi rõ bên dưới)", 
                  groupValue: selectedOption, 
                  onChanged: (value){
                    setState(() {
                      selectedOption = value;
                    });
                  }
                ),
                SizedBox(height: 5),
                TextField(
                  maxLength: 500,
                  controller: _otherReport,
                  enabled: selectedOption == 'Khác',
                  decoration: InputDecoration(
                    hintText: "Nhập nội dung",
                    hintStyle: TextStyle(
                      color: selectedOption == 'Khác' ? AppColors.black : AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: selectedOption == 'Khác' ? AppColors.black : AppColors.grey)
                    ),
                    counterText: ""
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: agree, 
                      onChanged: (value){
                        setState(() {
                          agree = value!;
                        });
                      }
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Tôi đồng ý cam kết thông tin trên là đúng sự thật",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                    ),
                    onPressed: () => Navigator.pop(context), 
                    child: Text(
                      "Hủy",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700
                      ),
                    )
                  ),
                ),
                SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // ignore: deprecated_member_use
                        backgroundColor: agree ? AppColors.green : AppColors.green.withOpacity(0.5),
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                      ),
                      onPressed: onReport, 
                      child: Text(
                        "Xác nhận",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                          ),
                        )
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}