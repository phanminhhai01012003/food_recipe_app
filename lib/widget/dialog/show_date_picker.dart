import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';

Future showAndroidDate(BuildContext context, String label, void Function(DateTime) onDateTimePicked) async{
  final datePicker = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), 
    firstDate: DateTime(1900), 
    lastDate: DateTime(2100),
    helpText: label,
    cancelText: "cancel".tr(),
    confirmText: "select".tr()
  );
  if (datePicker != null) {
    onDateTimePicked(datePicker);
  }
}

Future showIosDate(BuildContext context, void Function(DateTime) onDateTimePicked) async{
  final theme = Theme.of(context);
  return await showModalBottomSheet(
    context: context,
    // ignore: deprecated_member_use
    barrierColor: AppColors.black.withOpacity(0.25),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height / 2,
      color: theme.colorScheme.primary,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: onDateTimePicked,
        initialDateTime: DateTime.now(),
        minimumYear: 1900,
        maximumYear: 2100,
      ),
    )
  );
}