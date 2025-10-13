import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:food_recipe_app/model/notification_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class NotificationData {
  final notificationCollection = FirebaseFirestore.instance.collection("notification");
  Future<void> pushNotification(NotificationModel model) async{
    try {
      await notificationCollection.doc(model.id).set(model.toAllUserMap());
    } catch (e) {
      Message.showToast("Lỗi đẩy thông báo");
      Logger.log(e);
      rethrow;
    }
  }
  Future<void> updateReadNotifications(String id) async {
    try {
      await notificationCollection.doc(id).update({
        'isRead': true,
        'readAt': DateTime.now()
      });
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }
  Future<List<NotificationModel>> getAllNotifications(){
    try {
      return notificationCollection
        .get()
        .then((ss) => ss.docs.map((e) => NotificationModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }
  Future<List<NotificationModel>> getReadNotifications(bool isRead){
    try {
      return notificationCollection
        .where("isRead", isEqualTo: isRead)
        .get()
        .then((ss) => ss.docs.map((e) => NotificationModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }

}