import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';

class Benefit extends StatelessWidget {
  final Color color;
  const Benefit({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        borderRadius: BorderRadius.circular(12),
        color: color
      ),
      columnWidths: {
        0: FractionColumnWidth(0.5),
        1: FractionColumnWidth(0.25),
        2: FractionColumnWidth(0.25),
      },
      children: [
        row(["benefit".tr(), "free".tr(), "premiumPackage".tr()], true),
        row(["removeAd".tr(), "no".tr(), "yes".tr()], false),
        row(["foodCount".tr(), "1000 ${"food".tr()}", "unlimited".tr()], false),
        row(["recommendedFood".tr(), "random".tr(), "preferences".tr()], false),
        row(["searchFilter".tr(), "normal".tr(), "advanced".tr()], false),
        row(["cookbookCount".tr(), "100 ${"books".tr()}", "unlimited".tr()], false),
      ],
    );
  }

  TableRow row(List<String> cells, bool isHeader){
    return TableRow(
      children: cells.map((c) => Padding(
        padding: EdgeInsets.all(12),
        child: Text(c,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: isHeader ? 16 : 12,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal
          )
        ),
      )).toList()
    );
  }
}