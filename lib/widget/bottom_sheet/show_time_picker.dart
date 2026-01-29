import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:numberpicker/numberpicker.dart';

Future<Duration?> showTimePickerModal(BuildContext context, Duration? duration) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => ShowTimePicker(duration: duration)
  );
}

class ShowTimePicker extends StatefulWidget {
  final Duration? duration;
  const ShowTimePicker({super.key, required this.duration});

  @override
  State<ShowTimePicker> createState() => _ShowTimePickerState();
}

class _ShowTimePickerState extends State<ShowTimePicker> {
  late Duration _duration = Duration.zero;
  late int days = _duration.inDays.remainder(31);
  late int hr = _duration.inHours.remainder(24);
  late int min = _duration.inMinutes.remainder(60);
  late int sec = _duration.inSeconds.remainder(60);
  Duration get _onChanged {
    _duration = Duration(days: days, hours: hr, minutes: min, seconds: sec);
    return _duration;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.duration != null) {
      _duration = widget.duration!;
      days = _duration.inDays.remainder(31);
      hr = _duration.inHours.remainder(24);
      min = _duration.inMinutes.remainder(60);
      sec = _duration.inSeconds.remainder(60);
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: EdgeInsets.only(
        bottom: max(15, MediaQuery.viewInsetsOf(context).bottom), 
        left: 20, 
        right: 20
      ),
      width: double.infinity,
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
          Center(
            child: Text(
              "setupDuration".tr(),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 12,
                fontWeight: FontWeight.normal
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NumberPicker(
                      minValue: 0, 
                      maxValue: 30, 
                      value: days.clamp(0, 30),
                      infiniteLoop: true,
                      itemHeight: 50,
                      itemWidth: 50,
                      textStyle: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                      selectedTextStyle: TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                      ),
                      onChanged: (value) {
                        setState(() {
                          days = value;
                        });
                      }
                    ),
                    Text(
                      "d",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    NumberPicker(
                      minValue: 0, 
                      maxValue: 23, 
                      value: hr.clamp(0, 23),
                      infiniteLoop: true,
                      itemHeight: 50,
                      itemWidth: 50,
                      textStyle: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                      selectedTextStyle: TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                      ),
                      onChanged: (value) {
                        setState(() {
                          hr = value;
                        });
                      }
                    ),
                    Text(
                      "h",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    NumberPicker(
                      minValue: 0, 
                      maxValue: 59, 
                      value: min.clamp(0, 59),
                      infiniteLoop: true,
                      itemHeight: 50,
                      itemWidth: 50,
                      textStyle: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                      selectedTextStyle: TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                      ),
                      onChanged: (value) {
                        setState(() {
                          min = value;
                        });
                      }
                    ),
                    Text(
                      "m",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    NumberPicker(
                      minValue: 0, 
                      maxValue: 59, 
                      value: sec.clamp(0, 59),
                      infiniteLoop: true,
                      itemHeight: 50,
                      itemWidth: 50,
                      textStyle: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                      selectedTextStyle: TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                      ),
                      onChanged: (value) {
                        setState(() {
                          sec = value;
                        });
                      }
                    ),
                    Text(
                      "s",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () => Navigator.pop(context), 
                  child: Text(
                    "cancel".tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                    ),
                  )
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () => Navigator.pop(context, _onChanged), 
                  child: Text(
                    "confirm".tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                    ),
                  )
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}