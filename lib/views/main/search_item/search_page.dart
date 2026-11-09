import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/views/main/search_item/recent_searches.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_grid.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_list.dart';
import 'package:food_recipe_app/widget/load_data/load_data.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isGrid = false;
  List<String> recentSearches = [];
  final _searchController = TextEditingController();
  String? searchQuery;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rSearch = RecentSearches(recentSearches: recentSearches);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.secondary,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, 
              size: 20
            )
          ),
        ),
        actions: [
          Visibility(
            visible: _searchController.text.isNotEmpty,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isGrid = !isGrid;
                });
              },
              icon: Icon(
                isGrid ? Icons.grid_3x3 : Icons.list,
                size: 20,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              TextFormField(
                controller: _searchController,
                cursorColor: AppColors.blue,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(33),
                    borderSide: BorderSide(color: theme.colorScheme.secondary)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(33),
                    borderSide: BorderSide(color: AppColors.green)
                  ),
                  prefixIcon: Container(
                    alignment: Alignment.center,
                    width: 20,
                    height: 20,
                    child: Icon(Icons.search, color: AppColors.grey),
                  ),
                  hintText: "search".tr(),
                  hintStyle: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                  ),
                  suffixIcon: Visibility(
                    visible: _searchController.text.isNotEmpty,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          searchQuery = "";
                        });
                      }, 
                      icon: Icon(Icons.clear, size: 20, color: AppColors.grey)
                    ),
                  )
                ),
                onFieldSubmitted: (newValue) async{
                  await rSearch.saveSearchTerm(newValue);
                  setState(() {
                    searchQuery = newValue;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                }
              ),
              SizedBox(height: 20),
              if (recentSearches.isEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "recentSearches".tr(),
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          ShowYesnoDialog.checkDeviceDialog(
                            context, 
                            title: "", 
                            content: "", 
                            onAcceptTap: () async{
                              Navigator.pop(context);
                              await Future.delayed(Duration(seconds: 1));
                              rSearch.clearAllSearches();
                            }, 
                            onCancelTap: () => Navigator.pop(context)
                          );
                        }, 
                        icon: Icon(
                          Icons.delete,
                          size: 15,
                          color: theme.colorScheme.secondary,
                        )
                      )
                    ],
                  ),
                ),
              ],
              _searchController.text.isEmpty ? FutureBuilder(
                future: rSearch.loadRecentSearch(), 
                builder: (context, snapshot){
                  if (!snapshot.hasData || snapshot.hasError) {
                    return const SizedBox();
                  } else if (snapshot.connectionState == ConnectionState.waiting){ 
                    return LoadData(isList: true);
                  }else{
                    final recent = snapshot.data!;
                    return ListView.builder(
                      itemCount: recent.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index){
                        return ListTile(
                          onTap: () {
                            _searchController.text = recent[index];
                            setState(() {
                              searchQuery = recent[index];
                            });
                          },
                          leading: Icon(Icons.history, size: 20, color: AppColors.grey),
                          title: Text(recent[index],
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async{
                              await rSearch.removeSearchTerm(recent[index]);
                              setState((){});
                            },
                            icon: Icon(Icons.close, size: 20, color: AppColors.grey),
                          ),
                        );
                      },
                    );
                  }
                }
              ) : StreamBuilder(
                stream: foodServices.getFood(context),
                builder: (context, snapshot){
                  if (!snapshot.hasData || snapshot.hasError) {
                    return const SizedBox();
                  } else if (snapshot.connectionState == ConnectionState.waiting) { 
                    return LoadData(isList: isGrid);
                  } else {
                    var filterDoc = snapshot.data!
                      .where((e) => e.title.toLowerCase().contains(searchQuery ?? ""))
                      .toList();
                    if (isGrid) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: filterDoc.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) => FoodDisplayGrid(food: filterDoc[index])
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: filterDoc.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) => FoodDisplayList(food: filterDoc[index])
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}