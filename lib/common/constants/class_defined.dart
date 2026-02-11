import 'package:flutter/material.dart';
import 'package:food_recipe_app/services/authentication/auth_services.dart';
import 'package:food_recipe_app/services/firestore/comment/comment_services.dart';
import 'package:food_recipe_app/services/firestore/food_recipe/food_services.dart';
import 'package:food_recipe_app/services/firestore/other_data/other_data_services.dart';
import 'package:food_recipe_app/services/firestore/rate/rate_services.dart';
import 'package:food_recipe_app/services/firestore/report/report_services.dart';
import 'package:food_recipe_app/services/firestore/user/user_services.dart';
import 'package:food_recipe_app/services/image/image_service.dart';
import 'package:food_recipe_app/services/notification/notification_data.dart';
import 'package:food_recipe_app/services/shared/shared_preferences_service.dart';

//key
final navigatorKey = GlobalKey<NavigatorState>();

//class defined
final authServices = AuthServices();
final foodServices = FoodServices();
final imageServices = ImageService();
final userServices = UserServices();
final notificationData = NotificationData();
final commentServices = CommentServices();
final reportServices = ReportServices();
final rateServices = RateServices();
final spServices = SharedPreferencesService();
final otherServices = OtherDataServices();