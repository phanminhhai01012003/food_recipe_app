import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/list_constants.dart';

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
        row(benefitList.first, true),
        row(benefitList[1], false),
        row(benefitList[2], false),
        row(benefitList[3], false),
        row(benefitList[4], false),
        row(benefitList.last, false),
      ],
    );
  }

  TableRow row(List<String> cells, bool isHeader){
    return TableRow(
      children: cells.map((c) => Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text(c,
            style: TextStyle(
              color: color,
              fontSize: isHeader ? 16 : 12,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal
            )
          ),
        ),
      )).toList()
    );
  }
}