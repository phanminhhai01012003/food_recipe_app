class ReportModel {
  late String reportId;
  late String target;
  late String author;
  late String reporter;
  late String reason;
  late DateTime createdAt;
  late int status;
  ReportModel({
    required this.reportId,
    required this.target,
    required this.author,
    required this.reporter,
    required this.reason,
    required this.createdAt,
    required this.status
  });
  ReportModel.fromMap(Map<String, dynamic> data){
    reportId = data['reportId'] ?? "";
    target = data['target'] ?? "";
    author = data['author'] ?? "";
    reporter = data['reporter'] ?? "";
    reason = data['reason'] ?? "";
    createdAt = DateTime.tryParse(data['createdAt'] ?? "") ?? DateTime.now();
    status = data['status'] ?? 0;
  }
  Map<String, dynamic> toMap() => {
    "reportId": reportId,
    "target": target,
    "author": author,
    "reporter": reporter,
    "reason": reason,
    "createdAt": createdAt,
    "status": status
  };
}