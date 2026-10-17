import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/model/food/category_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CategoriesGridList extends StatefulWidget {
  const CategoriesGridList({super.key});

  @override
  State<CategoriesGridList> createState() => _CategoriesGridListState();
}

class _CategoriesGridListState extends State<CategoriesGridList> {

  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  List<List<CategoryModel>> chunkList(List<CategoryModel> list, int chunkSize){
    List<List<CategoryModel>> chunks = [];
    for (int i = 0; i < list.length; i++){
      chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder(
      stream: otherServices.getTags(context), 
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(child: Icon(Icons.error, size: 100, color: AppColors.red));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppColors.yellow));
        } else {
          final docs = snapshot.data!;
          List<List<CategoryModel>> pages = chunkList(docs, 6);
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final data = pages[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.8
                        ),
                        itemCount: data.length, 
                        itemBuilder: (context, idx){
                          final tag = data[idx];
                          if (tag.tag == "all") return SizedBox();
                          return GestureDetector(
                            onTap: () => Navigator.push(context, checkDeviceRoute(listofFoodByTag(tag.tag))),
                            child: Card(
                              elevation: 3,
                              color: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: NetworkImage(tag.image),
                                        fit: BoxFit.cover,
                                      )
                                    )
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    tag.tag.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: SmoothPageIndicator(
                  controller: _pageController, 
                  count: pages.length,
                  effect: SlideEffect(
                    activeDotColor: AppColors.green,
                    dotColor: AppColors.grey,
                    dotHeight: 10,
                    dotWidth: 10
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }
}