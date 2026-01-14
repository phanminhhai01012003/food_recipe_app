import 'package:flutter/material.dart';

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
        row(["Quyền lợi được hưởng", "Miễn phí", "Gói dịch vụ"], true),
        row(["Loại bỏ quảng cáo", "Không", "Có"], false),
        row(["Số lượng món ăn", "1000 món", "Không giới hạn"], false),
        row(["Đề xuất món ăn", "Ngẫu nhiên", "Theo sở thích cá nhân"], false),
        row(["Bộ lọc tìm kiếm", "Thông thường", "Nâng cao"], false),
        row(["Số lượng sổ tay", "100 cuốn", "Không giới hạn"], false),
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