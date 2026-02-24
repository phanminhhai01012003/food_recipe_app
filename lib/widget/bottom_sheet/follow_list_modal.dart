import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/user_model.dart';

Future followList(BuildContext context, List<UserModel> fList, String title) async{
  final theme = Theme.of(context);
  return await showModalBottomSheet(
    context: context,
    // ignore: deprecated_member_use
    barrierColor: AppColors.black.withOpacity(0.75),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    backgroundColor: theme.colorScheme.primary,
    builder: (context) => FollowListModal(fList: fList, title: title)
  );
}

class FollowListModal extends StatelessWidget {
  final List<UserModel> fList;
  final String title;
  const FollowListModal({super.key, required this.fList, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: BoxConstraints(maxHeight: 500),
      padding: EdgeInsets.all(16),
      child: Column(
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
          Text(
            "$title (${fList.length})",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 16,
              fontWeight: FontWeight.w800
            ),
          ),
          SizedBox(height: 20),
          ListView.builder(
            itemCount: fList.length,
            clipBehavior: Clip.hardEdge,
            hitTestBehavior: HitTestBehavior.translucent,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => InkWell(
              onTap: () => Navigator.push(context, checkDeviceRoute(personalScreen(fList[index].userId))),
              child: Container(
                color: theme.colorScheme.primary,
                padding: EdgeInsets.all(10),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(fList[index].avatar,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  title: Text(fList[index].userName,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}