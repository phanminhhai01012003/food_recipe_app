import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';

Future<Locale?> changeLanguageModal(BuildContext context) async{
  return await showModalBottomSheet(
    context: context,
    // ignore: deprecated_member_use
    barrierColor: AppColors.black.withOpacity(0.5), 
    builder: (context) => ChangeLanguageModal()
  );
}

class ChangeLanguageModal extends StatefulWidget {
  const ChangeLanguageModal({super.key});

  @override
  State<ChangeLanguageModal> createState() => _ChangeLanguageModalState();
}

class _ChangeLanguageModalState extends State<ChangeLanguageModal> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      width: double.infinity,
      padding: EdgeInsets.only(
        bottom: max(15, MediaQuery.viewInsetsOf(context).bottom), 
        left: 20, 
        right: 20
      ),
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
          Text(
            "Thay đổi ngôn ngữ",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 20),
          selectLanguageTileButton(
            context, 
            langImage: viFlag, 
            langTitle: "Tiếng Việt", 
            onChanged: (){},
            isSelected: true
          ),
          SizedBox(height: 10),
          selectLanguageTileButton(
            context, 
            langImage: enFlag, 
            langTitle: "English", 
            onChanged: (){},
            isSelected: false
          ),
        ],
      ),
    );
  }
  Widget selectLanguageTileButton(BuildContext context, {
    required String langImage,
    required String langTitle,
    required VoidCallback onChanged,
    required bool isSelected,
  }){
    final theme = Theme.of(context);
    return ListTile(
      onTap: onChanged,
      leading: Image.asset(
        langImage,
        fit: BoxFit.cover,
      ),
      title: Text(
        langTitle,
        style: TextStyle(
          color: theme.colorScheme.secondary,
          fontSize: 14,
          fontWeight: FontWeight.normal
        ),
      ),
      trailing: Visibility(
        visible: isSelected,
        child: Icon(
          Icons.check_circle,
          size: 20,
          color: AppColors.green,
        ),
      ),
    );
  }
}