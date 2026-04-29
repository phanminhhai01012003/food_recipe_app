import 'package:food_recipe_app/common/utils/logger.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/model/notification_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class NotificationData {  
  Future<void> pushNotification(NotificationModel model, bool isSpecificUser) async{
    try {
      await notificationCollection
        .doc(model.id)
        .set(isSpecificUser ? model.toSpecificUserMap() : model.toAllUserMap());
    } catch (e) {
      Message.showToast("notifyError".tr());
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
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }
  Future<List<NotificationModel>> getSpecificUserNotifications(String name){
    try {
      return notificationCollection
        .where("to", arrayContains: name)
        .get()
        .then((ss) => ss.docs.map((e) => NotificationModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }
  Future<List<NotificationModel>> getSystemNotifications(String type){
    try {
      return notificationCollection
        .where("type", isEqualTo: type)
        .get()
        .then((ss) => ss.docs.map((e) => NotificationModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }
  void pushInteractNotifications({
    required String id,
    required String title,
    required String body,
    String? from,
    List<dynamic>? to,
    Map<String, dynamic>? mainData,
    Map<String, dynamic>? extraData,
    required String type,
    required bool isRead,
    required DateTime createdAt
  }) async{
    NotificationModel model = NotificationModel(
      id: id, 
      title: title, 
      body: body, 
      from: from,
      to: to,
      type: type,
      mainData: mainData,
      extraData: extraData,
      isRead: isRead, 
      createdAt: createdAt
    );
    await pushNotification(model, true);
  }
}