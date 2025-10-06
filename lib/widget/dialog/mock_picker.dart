import 'package:flutter/material.dart';
import 'package:food_recipe_app/model/mock_case.dart';

class MockPicker extends StatelessWidget {
  final List<MockCase> mock;
  final String action;
  const MockPicker(this.mock, this.action, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              "Pick case for: $action",
              style: const TextStyle(
                color: Colors.white
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
                    color: Colors.white10,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mock[index].name,
                          style: const TextStyle(
                            color: Colors.white
                          ),
                        ),
                        Text(
                          mock[index].description,
                          style: const TextStyle(
                            color: Colors.white
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