import 'package:flutter/widgets.dart';
import 'package:food_recipe_app/model/report_model.dart';

abstract class ReportRepo {
  Future<void> addReport(BuildContext context, ReportModel report);
  Future<void> updateReport(BuildContext context, ReportModel report);
  Future<void> deleteReport(BuildContext context, String id);
  Stream<List<ReportModel>> getReportList(BuildContext context, String id, int status);
}