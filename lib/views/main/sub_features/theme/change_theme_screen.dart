import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/provider/theme_state.dart';
import 'package:provider/provider.dart';

class ChangeThemeScreen extends StatefulWidget {
  const ChangeThemeScreen({super.key});

  @override
  State<ChangeThemeScreen> createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends State<ChangeThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeState>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.green,
            foregroundColor: AppColors.white,
            title: Text("Chế độ giao diện",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Card(
                surfaceTintColor: AppColors.white,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: (){},
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Row(
                                children: [
                                  Positioned(
                                    top: 5,
                                    left: 5,
                                    child: Icon(
                                      Icons.sunny, 
                                      size: 10
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: Icon(
                                      Icons.dark_mode, 
                                      size: 10
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("Hệ thống",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: (){},
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Icon(
                                Icons.sunny, 
                                size: 20
                              )
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("Sáng",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: (){},
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Icon(
                                Icons.dark_mode,
                                size: 20,
                              )
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("Tối",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ),
            ),
          )
        );
      },
    );
  }
}