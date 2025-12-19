import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/model/notification_model.dart';
import 'package:food_recipe_app/services/notification/notification_data.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final firebaseMessaging = FirebaseMessaging.instance;
  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const androidInitSettings = AndroidInitializationSettings('assets/images/FoodDesign.png');
  static const iosInitSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true
  );
  static const initialSettings = InitializationSettings(
    android: androidInitSettings,
    iOS: iosInitSettings
  );
  static final notifyData = NotificationData();
  static const androidNotificationDetails = AndroidNotificationDetails(
    "123456789abcdef", 
    "Food Recipe notification channels",
    channelDescription: "Food Recipe App Notifications",
    importance: Importance.max,
    playSound: true,
    priority: Priority.defaultPriority,
    ticker: "Ticker"
  );
  static const iosNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true
  );
  static const notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails
  );
  static Future<void> initNotifications() async{
    tz.initializeTimeZones();
    await firebaseMessaging.requestPermission(
      provisional: true,
      announcement: true
    );
    final fcmToken = await firebaseMessaging.getToken();
    saveToken(fcmToken!);
    Logger.log("Token: $fcmToken");
    await initPushNotifications();
  }
  static Future<dynamic> initPushNotifications() async {
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      final title = message.notification?.title ?? "N/A";
      final body = message.notification?.body ?? "N/A";
      await saveNotification(title, body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
  }
  static Future<void> saveNotification(String title, String body) async {
    NotificationModel notify = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      title: title, 
      body: body, 
      type: "Hệ thống", 
      isRead: false, 
      createdAt: DateTime.now()
    );
    await notifyData.pushNotification(notify, false);
  }
  static void handleNotification(RemoteMessage? message){
    if (message == null) return;
    handleClickNotification(message.data);
  }
  static void handleClickNotification(Map<String, dynamic> data){
    if (data['type'] == "Hệ thống"){
      navigatorKey.currentState!.push(checkDeviceRoute(notification));
    } else if (data['type'] == "Thích bài viết"){
      navigatorKey.currentState!.push(
        checkDeviceRoute(
          foodDetailPage(
            FoodModel.fromMap(data['extraData']),
            List<Map<String, dynamic>>.from(data['extraData']['likedList'])
          )
        )
      );
    } else if (data['type'] == "Bình luận bài viết"){
      navigatorKey.currentState!.push(
        checkDeviceRoute(
          commentPage(
            FoodModel.fromMap(data['extraData'])
          )
        )
      );
    } else {
      navigatorKey.currentState!.push(
        checkDeviceRoute(
          replyPage(
            CommentModel.fromMap(data['extraData']),
            data['extraData']['foodId'].toString()
          )
        )
      );
    }
  }
  static void showNotification({
    required String title,
    required String body,
    required String payload
  }) {
    flutterLocalNotificationsPlugin.show(
      0, 
      title, 
      body, 
      notificationDetails,
      payload: payload
    );
  }
  static void scheduleNotification({
    required String title,
    required String body,
    required DateTime time
  }) {
    flutterLocalNotificationsPlugin.zonedSchedule(
      time.millisecondsSinceEpoch, 
      title, 
      body, 
      tz.TZDateTime.from(DateTime.now().add(Duration(seconds: 5)), tz.local), 
      notificationDetails, 
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, 
      androidScheduleMode: AndroidScheduleMode.exact
    );
  }
  static void saveToken(String token) async => await userCollection.doc(currentUser.uid).update({"token": token});
}