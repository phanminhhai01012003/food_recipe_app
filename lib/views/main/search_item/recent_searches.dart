import 'package:food_recipe_app/common/constants/class_defined.dart';

class RecentSearches {
  final List<String> recentSearches;
  RecentSearches({required this.recentSearches});
  set recentSearches(List<String> recentSearches) {
    this.recentSearches = recentSearches;
  }

  Future<void> saveSearchTerm(String term) async {
    recentSearches = await spServices.getStringListValue('recentSearches') ?? [];
    if (!recentSearches.contains(term)) {
      recentSearches.insert(0, term);
      if (recentSearches.length > 10) {
        recentSearches = recentSearches.sublist(0, 10);
      }
      await spServices.setStringListValue('recentSearches', recentSearches);
    }
  }

  Future<void> removeSearchTerm(String term) async {
    recentSearches = await spServices.getStringListValue('recentSearches') ?? [];
    recentSearches.remove(term);
    await spServices.setStringListValue('recentSearches', recentSearches);
  }

  Future<List<String>> loadRecentSearch() async {
    return await spServices.getStringListValue('recentSearches') ?? [];
  }

  Future<void> clearAllSearches() async {
    recentSearches = await spServices.getStringListValue('recentSearches') ?? [];
    recentSearches.clear();
    await spServices.setStringListValue('recentSearches', recentSearches);
  }

}
