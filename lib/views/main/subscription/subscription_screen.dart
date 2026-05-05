import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/model/app/subscription_model.dart';
import 'package:food_recipe_app/views/main/subscription/benefit.dart';
import 'package:food_recipe_app/views/main/subscription/subscription_widget.dart';
import 'package:food_recipe_app/widget/load_data/load_data.dart';
import 'package:food_recipe_app/widget/load_data/no_data.dart';

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
            StreamBuilder(
              stream: otherServices.getSubscriptions(context), 
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.hasError) {
                  return NoData();
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadData(isList: true);
                } else {
                  List<SubscriptionModel> data = snapshot.data!;
                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: data.length,
                    shrinkWrap: true,
                    hitTestBehavior: HitTestBehavior.translucent,
                    clipBehavior: Clip.hardEdge,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) => SubscriptionWidget(sub: data[index]),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Benefit(color: theme.colorScheme.secondary)
          ],
        ),
      )
    );
  }
}