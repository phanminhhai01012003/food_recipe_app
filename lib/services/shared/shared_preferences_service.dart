import 'package:food_recipe_app/common/configure/logger.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/services/shared/shared_preferences_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService extends SharedPreferencesRepo{
  @override
  Future<bool?> getBoolValue(String key) async{
    // TODO: implement getBoolValue
    try {
      final pref = await SharedPreferences.getInstance();
      final value = await pref.getBool(key);
      return value;
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<int?> getIntValue(String key) async{
    // TODO: implement getIntValue
    try {
      final pref = await SharedPreferences.getInstance();
      final value = await pref.getInt(key);
      return value;
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<List<String>?> getStringListValue(String key) async{
    // TODO: implement getStringListValue
    try {
      final pref = await SharedPreferences.getInstance();
      final value = await pref.getStringList(key);
      return value;
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<String?> getStringValue(String key) async{
    // TODO: implement getStringValue
    try {
      final pref = await SharedPreferences.getInstance();
      final value = await pref.getString(key);
      return value;
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> setBoolValue(String key, bool value) async{
    // TODO: implement setBoolValue
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.setBool(key, value);
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> setIntValue(String key, int value) async{
    // TODO: implement setIntValue
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.setInt(key, value);
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> setStringListValue(String key, List<String> value) async{
    // TODO: implement setStringListValue
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.setStringList(key, value);
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> setStringValue(String key, String value) async{
    // TODO: implement setStringValue
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.setString(key, value);
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

}