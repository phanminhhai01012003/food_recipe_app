class UserModel {
  late String userId;
  late String userName;
  late String avatar;
  late String nickName;
  late String description;
  late String email;
  late String phone;
  late String loginMethod;
  UserModel({
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.nickName,
    required this.email,
    required this.description,
    required this.phone,
    required this.loginMethod
  });
  factory UserModel.fromMap(Map<String, dynamic> data){
    return UserModel(
      userId: data['userId'] ?? "",
      userName: data['username'] ?? "",
      avatar: data['avatar'] ?? "",
      description: data['description'] ?? "",
      nickName: data['nickName'] ?? "",
      email: data['email'] ?? "",
      phone: data['phone'] ?? "",
      loginMethod: data['loginMethod'] ?? "",
    );
  }
  Map<String, dynamic> toMap() => {
    "userId": userId,
    "username": userName,
    "avatar": avatar,
    "description": description,
    "nickName": nickName,
    "email": email,
    "phone": phone,
    "loginMethod": loginMethod
  };
  Map<String, dynamic> updateMap() => {
    "username": userName,
    "avatar": avatar,
    "description": description,
    "nickName": nickName,
    "phone": phone
  };
  UserModel.empty(){
    userId = "";
    userName = "";
    avatar = "";
    description = "";
    nickName = "";
    email = "";
    phone = "";
    loginMethod = "";
  }
}