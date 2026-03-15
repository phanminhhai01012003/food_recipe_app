import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/data/mock_case.dart';

class MockPicker extends StatelessWidget {
  final List<MockCase> mock;
  final String action;
  const MockPicker(this.mock, this.action, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
        backgroundColor: theme.colorScheme.primary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              "Pick case for: $action",
              style: TextStyle(
                color: AppColors.white
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: mock.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(mock[index].response);
                  },
                  child: Container(
                    color: theme.colorScheme.primary,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mock[index].name,
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          mock[index].description,
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      );
  }
}