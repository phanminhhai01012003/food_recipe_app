import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/widget/dialog/no_internet_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InternetCheck extends StatefulWidget {
  const InternetCheck({super.key});

  @override
  State<InternetCheck> createState() => _InternetCheckState();
}

class _InternetCheckState extends State<InternetCheck> {
  bool checking = true;
  final _auth = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async{
    setState(() {
      checking = true;
    });
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      _navigation();
    }else {
      showNoInternetDialog(context, 
        onPressed: () {
          Navigator.pop(context);
          checkInternetConnection();
        }
      );
    }
  }

  bool get checkAuthentication => _auth != null;

  void _navigation() async{
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_seen') ?? false;
    Navigator.pushAndRemoveUntil(
      context,
      checkDeviceRoute(seen ? (checkAuthentication ? mainPage : loginPage) : onboardScreen), 
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: checking ? CircularProgressIndicator(color: AppColors.black) : SizedBox()),
    );
  }
}