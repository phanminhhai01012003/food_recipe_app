import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/data/dummy_data.dart';
import 'package:food_recipe_app/views/main/subscription/benefit.dart';
import 'package:food_recipe_app/views/main/subscription/subscription_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>{
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.secondary,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              size: 20,
            )
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ListView.builder(
              itemCount: subscriptionData.length,
              shrinkWrap: true,
              hitTestBehavior: HitTestBehavior.translucent,
              clipBehavior: Clip.hardEdge,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) => SubscriptionWidget(sub: subscriptionData[index]),
            ),
            SizedBox(height: 20),
            Benefit(color: theme.colorScheme.secondary)
          ],
        ),
      )
    );
  }
}