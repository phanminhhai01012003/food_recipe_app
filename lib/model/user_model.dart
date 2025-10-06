class UserModel {
  late String userId;
  late String userName;
  late String avatar;
  late String description;
  late String email;
  late String phone;
  late String loginMethod;
  UserModel({
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.email,
    required this.description,
    required this.phone,
    required this.loginMethod
  });
  UserModel.fromMap(Map<String, dynamic> data){
    userId = data['userId'] ?? "";
    userName = data['username'] ?? "";
    avatar = data['avatar'] ?? "";
    description = data['description'] ?? "";
    email = data['email'] ?? "";
    phone = data['phone'] ?? "";
    loginMethod = data['loginMethod'] ?? "";
  }
  Map<String, dynamic> toMap() => {
    "userId": userId,
    "username": userName,
    "avatar": avatar,
    "description": description,
    "email": email,
    "phone": phone,
    "loginMethod": loginMethod
  };
  Map<String, dynamic> updateMap() => {
    "username": userName,
    "avatar": avatar,
    "description": description,
    "phone": phone
  };
}