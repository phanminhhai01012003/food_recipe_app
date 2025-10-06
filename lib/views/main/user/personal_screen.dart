import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/services/firestore/food_recipe/food_services.dart';
import 'package:food_recipe_app/services/firestore/user/user_services.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_grid.dart';

class PersonalScreen extends StatefulWidget {
  final String id;
  const PersonalScreen({super.key, required this.id});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final userServices = UserServices();
  final foodServices = FoodServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        title: Text("Trang cá nhân",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: userServices.getUserById(context, widget.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.hasError) {
                return SizedBox();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: AppColors.yellow));
              } else{
                List<UserModel> userData = snapshot.data!;
                return ListView.builder(
                  itemCount: userData.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => userInform(user: userData[index])
                );
              }
            },
          ),
          SizedBox(height: 20),
          Divider(color: AppColors.grey, thickness: 1),
          SizedBox(height: 20),
          StreamBuilder(
            stream: foodServices.getFoodByUser(context, widget.id), 
            builder: (context, snapshot){
              if (!snapshot.hasData || snapshot.hasError) {
                return Center(child: Icon(Icons.error, size: 100, color: AppColors.red));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: AppColors.yellow));
              } else {
                List<FoodModel> foodData = snapshot.data!;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: foodData.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => FoodDisplayGrid(food: foodData[index])
                );
              }
            }
          )
        ],
      ),
    );
  }
  Widget userInform({required UserModel user}){
    return ListTile(
      tileColor: AppColors.green,
      textColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          imageUrl: user.avatar,
          progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator(value: progress.progress, color: AppColors.yellow)),
          width: 50,
          height: 50,
          errorWidget: (context, url, error) => Image.asset(userDefaultImage),
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        user.userName,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800
        ),
      ),
      subtitle: Expanded(
        child: Text(
          user.description,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }
}