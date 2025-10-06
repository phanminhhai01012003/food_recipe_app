import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/services/firestore/food_recipe/food_services.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_list.dart';
import 'package:food_recipe_app/widget/other/load_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> recentSearches = [];
  final _foodServices = FoodServices();
  final _searchController = TextEditingController();
  String? searchQuery;
  Future<void> saveSearchTerm(String term) async{
    final prefs = await SharedPreferences.getInstance();
    recentSearches = prefs.getStringList('recentSearches') ?? [];
    if (!recentSearches.contains(term)) {
      recentSearches.insert(0, term);
      if (recentSearches.length > 10) {
        recentSearches = recentSearches.sublist(0, 10);
      }
      await prefs.setStringList('recentSearches', recentSearches);
    }
  }
  Future<void> removeSearchTerm(String term) async{
    final prefs = await SharedPreferences.getInstance();
    recentSearches = prefs.getStringList('recentSearches') ?? [];
    recentSearches.remove(term);
    await prefs.setStringList('recentSearches', recentSearches);
  }
  Future<List<String>> loadRecentSearch() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('recentSearches') ?? [];
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRecentSearch();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              cursorColor: AppColors.blue,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(33),
                  borderSide: BorderSide(color: AppColors.black)
                ),
                prefixIcon: Container(
                  alignment: Alignment.center,
                  width: 20,
                  height: 20,
                  child: Icon(Icons.search, color: AppColors.grey),
                ),
                hintText: "Tìm kiếm",
                hintStyle: TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchController.clear();
                    searchQuery = "";
                  }, 
                  icon: Icon(Icons.clear, size: 20, color: AppColors.grey)
                )
              ),
              onSaved: (newValue) {
                setState(() {
                  saveSearchTerm(newValue!);
                });
              },
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              }
            ),
            SizedBox(height: 50),
            _searchController.text.isEmpty ? FutureBuilder(
              future: loadRecentSearch(), 
              builder: (context, snapshot){
                if (!snapshot.hasData || snapshot.hasError) {
                  return const SizedBox();
                } else if (snapshot.connectionState == ConnectionState.waiting){ 
                  return LoadData(isList: true);
                }else{
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return ListTile(
                        onTap: () {
                          _searchController.text = recentSearches[index];
                          setState(() {
                            searchQuery = recentSearches[index];
                          });
                        },
                        leading: Icon(Icons.history, size: 20, color: AppColors.grey),
                        title: Text(recentSearches[index],
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            removeSearchTerm(recentSearches[index]);
                            setState(() {
                              recentSearches.removeAt(index);
                            });
                          },
                          icon: Icon(Icons.close, size: 20, color: AppColors.grey),
                        ),
                      );
                    },
                  );
                }
              }
            ) : StreamBuilder(
              stream: _foodServices.getFood(context),
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
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => FoodDisplayList(food: filterDoc[index])
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}