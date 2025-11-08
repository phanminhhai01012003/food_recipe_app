import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';

class Selection extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  const Selection({
    super.key,
    required this.onTap, 
    required this.icon, 
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      tileColor: theme.colorScheme.primary,
      onTap: onTap,
      leading: Icon(icon, size: 20, color: AppColors.grey),
      title: Text(title,
        style: TextStyle(
          color: theme.colorScheme.secondary,
          fontSize: 14,
          fontWeight: FontWeight.normal
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 20, color: AppColors.grey),
    );
  }
}