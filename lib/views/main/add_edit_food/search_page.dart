import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_list.dart';
import 'package:food_recipe_app/widget/load_data/load_data.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> recentSearches = [];
  final _searchController = TextEditingController();
  String? searchQuery;
  Future<void> saveSearchTerm(String term) async{
    recentSearches = await spServices.getStringListValue('recentSearches') ?? [];
    if (!recentSearches.contains(term)) {
      recentSearches.insert(0, term);
      if (recentSearches.length > 10) {
        recentSearches = recentSearches.sublist(0, 10);
      }
      await spServices.setStringListValue('recentSearches', recentSearches);
    }
  }
  Future<void> removeSearchTerm(String term) async{
    recentSearches = await spServices.getStringListValue('recentSearches') ?? [];
    recentSearches.remove(term);
    await spServices.setStringListValue('recentSearches', recentSearches);
  }
  Future<List<String>> loadRecentSearch() async{
    return await spServices.getStringListValue('recentSearches') ?? [];
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  border: OutlineInputBorder(
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
                  await saveSearchTerm(newValue);
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
              _searchController.text.isEmpty ? FutureBuilder(
                future: loadRecentSearch(), 
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
                              await removeSearchTerm(recent[index]);
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
                    return Center(child: CircularProgressIndicator(color: AppColors.yellow));
                  } else {
                    var filterDoc = snapshot.data!.where((e){
                      return e.title.toLowerCase().contains(searchQuery!);
                    }).toList();
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