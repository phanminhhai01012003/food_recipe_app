import 'package:flutter/material.dart';

class StatsContainer extends StatelessWidget {
  final String title;
  final Widget data;
  const StatsContainer({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.secondary)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 12,
              fontWeight: FontWeight.normal
            ),
          ),
          SizedBox(height: 5),
          data
        ],
      ),     
    );
  }
}