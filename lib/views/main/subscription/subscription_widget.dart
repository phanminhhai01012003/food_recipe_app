import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/configure/extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';

class SubscriptionWidget extends StatefulWidget {
  final Map<String, dynamic> sub;
  const SubscriptionWidget({super.key, required this.sub});

  @override
  State<SubscriptionWidget> createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends State<SubscriptionWidget> {
  Color renderBgColor(String time){
    return switch(time) {
      "1 tháng" => AppColors.blue,
      "1 năm" => AppColors.green,
      _ => AppColors.black
    };
  }
  String priceFormat(String price, String priceUnit) {
    if (priceUnit == "đ"){
      return price.priceFormat + priceUnit;
    }
    return priceUnit + price.priceFormat;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: renderBgColor(widget.sub['time']),
        borderRadius: BorderRadius.circular(12)
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.sub['subscriptionName'],
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700
                ),
              ),
              Text(
                "${priceFormat(widget.sub['price'], widget.sub['priceUnit'])}/${widget.sub['time']}",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
          TextButton(
            onPressed: (){}, 
            child: Text(
              "Mua",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            )
          )
        ],
      ),
    );
  }
}