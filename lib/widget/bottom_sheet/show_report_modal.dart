import 'dart:math';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/constants/list_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/convert.dart';
import 'package:food_recipe_app/model/report_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/other/radio_selection.dart';
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
  void onReport() async{
    if (!agree) return;
    context.loaderOverlay.show();
    if (selectedOption!.contains("Khác")){
      if (_otherReport.text.isEmpty){
        Message.showToast("Vui lòng điền đầy đủ thông tin");
        context.loaderOverlay.hide();
        return;
      }
    }
    ReportModel report = ReportModel(
      reportId: generateRandomString(20), 
      target: widget.title,
      author: widget.author,
      reporter: currentUser.displayName!,
      reason: selectedOption == "reportOther".tr() ? _otherReport.text : selectedOption!, 
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
      if (widget.title.contains("món")) {
        if (selectedOption == reportFoodList.last) {
          _otherReport.text = widget.reports!.reason;
        } else {
          selectedOption = widget.reports!.reason;
        }
      } else {
        if (selectedOption == reportCommentList.last) {
          _otherReport.text = widget.reports!.reason;
        } else {
          selectedOption = widget.reports!.reason;
        }
      }
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
    final theme = Theme.of(context);
    return Container(
      constraints: BoxConstraints(maxHeight: 700),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
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
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  "${"reportBlockForSomeone".tr()} ${widget.title} ${"for".tr()} ${widget.author}",
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.normal
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "reportReason".tr(),
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: List.generate(
                    widget.title.contains("food".tr()) 
                      ? reportFoodList.length
                      : reportCommentList.length, 
                    (i) => RadioSelection(
                      title: widget.title.contains("food".tr()) 
                        ? reportFoodList[i]
                        : reportCommentList[i], 
                      selectedOption: selectedOption, 
                      onTap: (){
                        setState(() {
                          if (widget.title.contains("food".tr())) {
                            selectedOption = reportFoodList[i];
                          } else {
                            selectedOption = reportCommentList[i];
                          }
                        });
                      }, 
                      onChanged: (value){
                        setState(() {
                          selectedOption = value;
                        });
                      }
                    )
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  maxLength: 500,
                  controller: _otherReport,
                  enabled: widget.title.contains("food".tr()) 
                    ? selectedOption == reportFoodList.last 
                    : selectedOption == reportCommentList.last,
                  decoration: InputDecoration(
                    hintText: "contentInput".tr(),
                    hintStyle: TextStyle(
                      color: selectedOption == "reportOther".tr() 
                        ? theme.colorScheme.secondary 
                        : AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: selectedOption == "reportOther".tr()
                          ? AppColors.black 
                          : AppColors.grey
                      )
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
                    Text(
                      "agreeForTrue".tr(),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 11,
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
                          "cancel".tr(),
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
                          "confirm".tr(),
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