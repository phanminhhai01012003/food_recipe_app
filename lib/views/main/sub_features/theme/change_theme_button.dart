import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';

class ChangeThemeButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool screenState;
  final IconData themeIcon;
  final String text;
  const ChangeThemeButton({
    super.key, 
    required this.onTap, 
    required this.screenState, 
    required this.themeIcon, 
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: screenState ? AppColors.green : theme.colorScheme.primary
            ),
            child: Icon(
              Icons.auto_mode,
              size: 20,
              color: screenState ? AppColors.white : theme.colorScheme.secondary,
            )
          ),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal
            ),
          )
        ],
      ),
    );
  }
}