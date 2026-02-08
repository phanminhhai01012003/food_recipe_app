abstract class SharedPreferencesRepo {
  Future<void> setStringValue(String key, String value);
  Future<String?> getStringValue(String key);
  Future<void> setIntValue(String key, int value);
  Future<int?> getIntValue(String key);
  Future<void> setBoolValue(String key, bool value);
  Future<bool?> getBoolValue(String key);
  Future<void> setStringListValue(String key, List<String> value);
  Future<List<String>?> getStringListValue(String key);
}