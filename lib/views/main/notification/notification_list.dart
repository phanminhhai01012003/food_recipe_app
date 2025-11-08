import 'package:flutter/material.dart';

class NotificationList extends StatefulWidget {
  final Widget imageWidget;
  final String title;
  final String date;
  const NotificationList({
    super.key, 
    required this.imageWidget, 
    required this.title, 
    required this.date
  });

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              widget.imageWidget,
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  widget.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800
                  ),
                ),
              ),         
            ],
          ),
          Text(
            widget.date,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 10,
              fontWeight: FontWeight.w300
            ),
          ),
        ],
      ),
    );
  }
}