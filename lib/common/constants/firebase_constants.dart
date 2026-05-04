import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//authentication
final auth = FirebaseAuth.instance;
final currentUser = auth.currentUser!;

//firestore
final userCollection = FirebaseFirestore.instance.collection("users");
final foodCollection = FirebaseFirestore.instance.collection("food_recipe");
final fridgeCollection = FirebaseFirestore.instance.collection("smartFridge");
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
final subCollection = FirebaseFirestore.instance.collection("subscription");
final rateCollection = FirebaseFirestore.instance.collection("rating");
CollectionReference<Map<String, dynamic>> delAccReqCollection(String userId) {
  return userCollection
    .doc(userId)
    .collection("delete_acc_request");
}
CollectionReference<Map<String, dynamic>> followCollection(String userId) {
  return userCollection
    .doc(userId)
    .collection("follow_list"); 
}

//storage
String foodFolder = "food_recipe";
String avatarFolder = "user_avatar";
String cookbookFolder = "cookbook";
String ingredientFolder = "ingredient";