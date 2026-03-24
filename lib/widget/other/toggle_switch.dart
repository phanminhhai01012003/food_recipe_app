import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';

class ToggleSwitch {
  static Widget materialToggle(bool isAI, void Function(bool) onChanged) {
    return Switch.adaptive(
      value: isAI, 
      activeColor: AppColors.green,
      // ignore: deprecated_member_use
      activeTrackColor: AppColors.green.withOpacity(0.5),
      inactiveThumbColor: AppColors.grey,
      // ignore: deprecated_member_use
      inactiveTrackColor: AppColors.grey.withOpacity(0.5),
      onChanged: onChanged
    );
  }
  static Widget cupertinoToggle(bool isAI, void Function(bool) onChanged) {
    return CupertinoSwitch(
      value: isAI,
      // ignore: deprecated_member_use
      activeColor: AppColors.green,
      // ignore: deprecated_member_use
      activeTrackColor: AppColors.green.withOpacity(0.5),
      inactiveThumbColor: AppColors.grey,
      // ignore: deprecated_member_use
      inactiveTrackColor: AppColors.grey.withOpacity(0.5),
      onChanged: onChanged,
    );
  }
  static Widget toggleDependsOnDevice(bool isAI, void Function(bool) onChanged) {
    return Platform.isAndroid ? materialToggle(isAI, onChanged) : cupertinoToggle(isAI, onChanged);
  }
}