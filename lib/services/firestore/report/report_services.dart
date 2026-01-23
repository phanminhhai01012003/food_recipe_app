import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/logger.dart';
import 'package:food_recipe_app/model/report_model.dart';
import 'package:food_recipe_app/services/firestore/report/report_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class ReportServices extends ReportRepo{

  @override
  Future<void> addReport(BuildContext context, ReportModel report) async{
    // TODO: implement addReport
    try { 
      await reportCollection.doc(report.reportId).set(report.toMap());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteReport(BuildContext context, String id) async{
    // TODO: implement deleteReport
    try { 
      await reportCollection.doc(id).delete();
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Stream<List<ReportModel>> getReportList(BuildContext context, String name, int status) {
    // TODO: implement getReportList
    try { 
      return reportCollection
        .where("reporter", isEqualTo: name)
        .where("status", isEqualTo: status)
        .snapshots()
        .map((event) => event.docs.map((doc) => ReportModel.fromMap(doc.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> updateReport(BuildContext context, ReportModel report) async{
    // TODO: implement updateReport
    try { 
      await reportCollection.doc(report.reportId).update(report.toMap());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

}