import 'package:flutter/material.dart';

//images
String imagePath = "assets/images";
String foodDesignImage = "$imagePath/FoodDesign.png";
String ggImage = "$imagePath/gg.png";
String fbImage = "$imagePath/fb.png";
String foodImage = "$imagePath/food.png";
String cookingImage = "$imagePath/cooking.png";
String userDefaultImage = "$imagePath/user.png";

//key
final navigatorKey = GlobalKey<NavigatorState>();
final formKey = GlobalKey<FormState>();

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

//cloudinary
String cloudName = "dyfzthrdv";
String folder = "/avatar";
String apiKey = "949323413611473";
String apiSecret = "DzxVBsgnO_0va_sYz0sdsVGjG5E";

//document
String docPath = "assets/document";
String pdfFile = "$docPath/document.pdf";