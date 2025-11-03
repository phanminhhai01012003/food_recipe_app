import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/services/authentication/auth_services.dart';
import 'package:food_recipe_app/services/firestore/comment/comment_services.dart';
import 'package:food_recipe_app/services/firestore/food_recipe/food_services.dart';
import 'package:food_recipe_app/services/firestore/report/report_services.dart';
import 'package:food_recipe_app/services/firestore/user/user_services.dart';
import 'package:food_recipe_app/services/image/image_service.dart';
import 'package:food_recipe_app/services/notification/notification_data.dart';
import 'package:food_recipe_app/views/main/categories/tag_services.dart';

//images
String imagePath = "assets/images";
String foodDesignImage = "$imagePath/FoodDesign.png";
String foodDefaultImage = "https://images.unsplash.com/photo-1556910096-6f5e72db6803?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
String ggImage = "$imagePath/gg.png";
String fbImage = "$imagePath/fb.png";
String foodImage = "$imagePath/food.png";
String cookingImage = "$imagePath/cooking.png";
String userDefaultImage = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ71Tc9Tk2q1eJUUlX1bXhWrc0-g8O9xnAplw&s";

//key
final navigatorKey = GlobalKey<NavigatorState>();

//lists
List<String> categoryList = [
  "Bò", 
  "Gà", 
  "Hải sản", 
  "Lẩu/Nướng", 
  "Lợn", 
  "Canh/Cháo/Súp", 
  "Bánh mì/Ăn vặt", 
  "Tráng miệng/Bánh ngọt", 
  "Rau/củ/quả", 
  "Đặc sản/Đặc trưng",
  "Hỗn hợp",
  "Khác"
];
List<String> sliderImage = [
  "https://plus.unsplash.com/premium_photo-1728412897842-06f0fc4c2ec6?q=80&w=1245&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "https://plus.unsplash.com/premium_photo-1672938878598-31c1c614f708?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "https://plus.unsplash.com/premium_photo-1670601440146-3b33dfcd7e17?q=80&w=1238&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "https://plus.unsplash.com/premium_photo-1684952849219-5a0d76012ed2?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "https://images.unsplash.com/photo-1556910096-6f5e72db6803?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
];
List<String> reportFoodList = [
  "Món ăn kém chất lượng hoặc không đảm bảo vệ sinh an toàn thực phẩm",
  "Hình ảnh chứa nội dung nhạy cảm, đồi trụy (quảng cáo trá hình, khiêu dâm, kích động bạo lực, ...)",
  "Sử dụng một số từ ngữ thô tục, xúc phạm danh dự của người khác",
  "Nội dung đăng tải giả mạo, không đúng sự thật",
  "Khác (vui lòng ghi rõ bên dưới)"
];
List<String> reportCommentList = [
  "Sử dụng một số từ ngữ thô tục, tiêu cực, không phù hợp",
  "Xúc phạm danh dự, gây ảnh hưởng đến tâm lý của người khác",
  "Quảng cáo trá hình, bán hàng trái phép",
  "Lộ thông tin bảo mật (số điện thoại, định danh cá nhân, ...)",
  "Khác (vui lòng ghi rõ bên dưới)"
];
List<String> deleteUserList = [
  "Tôi không muốn sử dụng ứng dụng này nữa",
  "Tài khoản có dấu hiệu bị rò rỉ dữ liệu",
  "Tôi muốn bỏ tài khoản này và tạo tài khoản khác",
  "Tôi muốn bảo vệ quyền lợi của mình",
  "Khác (vui lòng ghi rõ bên dưới)"
];

//storage
String foodFolder = "food_recipe";
String avatarFolder = "user_avatar";
String cookbookFolder = "cookbook";

//document
String docPath = "assets/document";
String pdfFile = "$docPath/document.pdf";

//firebase
final auth = FirebaseAuth.instance;
final currentUser = auth.currentUser!;
final userCollection = FirebaseFirestore.instance.collection("users");
final foodCollection = FirebaseFirestore.instance.collection("food_recipe");
CollectionReference<Map<String, dynamic>> commentCollection(String foodId){
  return FirebaseFirestore.instance
    .collection("food_recipe")
    .doc(foodId)
    .collection("comment");
}
final notificationCollection = FirebaseFirestore.instance.collection("notification");
final saveCollection = FirebaseFirestore.instance.collection("saved");
final historyCollection = FirebaseFirestore.instance.collection("history");
final bookCollection = FirebaseFirestore.instance.collection("cookbook");
final reportCollection = FirebaseFirestore.instance.collection("report");
final tagCollection = FirebaseFirestore.instance.collection("categories");
CollectionReference<Map<String, dynamic>> delAccReqCollection(String userId) {
  return userCollection
    .doc(userId)
    .collection("delete_acc_request");
} 

//class defined
final authServices = AuthServices();
final foodServices = FoodServices();
final imageServices = ImageService();
final tagServices = TagServices();
final userServices = UserServices();
final notificationData = NotificationData();
final commentServices = CommentServices();
final reportServices = ReportServices();