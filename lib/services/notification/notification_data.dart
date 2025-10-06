import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:food_recipe_app/model/notification_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class NotificationData {
  final notificationCollection = FirebaseFirestore.instance.collection("notification");
  Future<void> pushNotification(NotificationModel model) async{
    try {
      await notificationCollection.doc(model.id).set(model.toMap());
    } catch (e) {
      Message.showToast("Lỗi đẩy thông báo");
      Logger.log(e);
      rethrow;
    }
  }
  Future<void> updateReadNotifications(String id) async {
    try {
      await notificationCollection.doc(id).update({'isRead': true});
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }
}