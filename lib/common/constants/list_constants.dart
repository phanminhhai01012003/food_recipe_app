import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/common/configure/routes.dart';

List<String> categoryList = [
  "tagBeef", 
  "tagChicken", 
  "tagSeafood", 
  "tagHotpotGrill", 
  "tagPork", 
  "tagSoup", 
  "tagBread", 
  "tagDessert", 
  "tagVegetables", 
  "tagCharacteristics",
  "tagMix",
  "tagOther"
];
List<String> sliderImage = [
  "https://plus.unsplash.com/premium_photo-1728412897842-06f0fc4c2ec6?q=80&w=1245&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "https://plus.unsplash.com/premium_photo-1672938878598-31c1c614f708?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "https://plus.unsplash.com/premium_photo-1670601440146-3b33dfcd7e17?q=80&w=1238&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "https://plus.unsplash.com/premium_photo-1684952849219-5a0d76012ed2?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "https://images.unsplash.com/photo-1556910096-6f5e72db6803?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
];
List<String> reportFoodList = [
  "reportFoodNotHygiene",
  "reportFoodContainOffense",
  "reportFoodContainVulgarWord",
  "reportFoodNotReal",
  "reportOther"
];
List<String> reportCommentList = [
  "reportCommentContainVulgarWord",
  "reportCommentDamages",
  "reportCommentIllegalAd",
  "reportCommentWithSecurity",
  "reportOther"
];
List<String> reportUserList = [
  "doubt",
  "reportUserBehavior",
  "reportUserInform",
  "reportUserPost",
  "reportOther"
];
List<String> deleteUserList = [
  "dontwanttouse",
  "leakData",
  "useOtherAcc",
  "protect",
  "reportOther"
];
List<String> rates = [
  "rateInApp",
  "rateInStore"
];
List<String> filterRating = [
  "popular",
  "latest",
  "oldest"
];
List<Widget> pages = [
  homeScreen, 
  categoriesPage, 
  foodStorageView, 
  settings
];
List<DeviceOrientation> orientations = [
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
  DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight
];