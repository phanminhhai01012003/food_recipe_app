import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/recent_view_model.dart';
import 'package:food_recipe_app/provider/history_state.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/other/slider.dart';
import 'package:provider/provider.dart';

class RecentView extends StatefulWidget {
  const RecentView({super.key});

  @override
  State<RecentView> createState() => _RecentViewState();
}

class _RecentViewState extends State<RecentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        title: Text(
          "Đã xem gần đây",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Selector<HistoryState, List<RecentViewModel>>(
        selector: (context, state) => state.viewProducts,
        shouldRebuild: (previous, next) => true,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error, 
                    size: 50, 
                    color: AppColors.red
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Không có dữ liệu",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal
                    ),
                  )
                ],
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            hitTestBehavior: HitTestBehavior.translucent,
            clipBehavior: Clip.hardEdge,
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            itemCount: value.length,
            itemBuilder: (context, index) => SliderWidget(
              food: value[index].foods, 
              children: [
                SlidableAction(
                  onPressed: (context) => context.read<HistoryState>().toggle(value[index]),
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
                  icon: Icons.delete,
                )
              ]
            )
          );
        },
      ),
    );
  }
  void onDelete(BuildContext context, RecentViewModel model) {
    ShowYesnoDialog.checkDeviceDialog(
      context, 
      title: "Xóa lịch sử", 
      content: "Bạn có chắc chắn muốn xóa món ăn gần đây bạn đã xem không?", 
      onAcceptTap: () {
        context.read<HistoryState>().toggle(model);
        Message.showScaffoldMessage(context, "Đã xóa", AppColors.green);
        Navigator.pop(context);
      }, 
      onCancelTap: () => Navigator.pop(context)
    );
  }
}