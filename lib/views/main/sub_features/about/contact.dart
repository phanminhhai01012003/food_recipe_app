import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(foodDesignImage,
            width: MediaQuery.of(context).size.width * 0.5,
            height: 100,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20),
            Text("PMH Food Recipe",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 50),
            Text("Created by Phan Minh Hai",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 20),
            Text("Version: 1.0",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 20),
            Text("Thông tin liên hệ:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 20),
            Text("Email: hai0188766@huce.edu.vn",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 20),
            Text("Phone: 0984238803",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 20),
            Text("Name: Phan Minh Hai",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
              ),
            ),
        ],
      ),
    );
  }
}