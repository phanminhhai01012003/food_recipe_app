import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  double progress = 0.0;
  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
    Timer(Duration(seconds: 5), () {
      setState(() {
        _showProgress = true;
      });
      Timer.periodic(Duration(milliseconds: 5), (timer) {
        setState(() {
          progress += 0.01;
          if (progress > 1.0) {
            progress = 1.0;
            timer.cancel();
            Navigator.pushAndRemoveUntil(
              context, 
              checkDeviceRoute(internetCheck), 
              (route) => false
            );
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(foodDesignImage,
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 50),
            Visibility(
              visible: _showProgress,
              child: LinearPercentIndicator(
                percent: progress,
                lineHeight: 20,
                center: Text("${(progress * 100).toInt()}%"),
                backgroundColor: AppColors.grey,
                progressColor: AppColors.green,
                animation: true,
                animateFromLastPercent: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}