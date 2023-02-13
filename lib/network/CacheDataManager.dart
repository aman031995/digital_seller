import 'dart:async';

import 'package:hive_flutter/adapters.dart';
import 'package:json_cache/json_cache.dart';

class CacheDataManager {
  static cacheData({required String key, required Map<String, dynamic> jsonData}) async {
    final box = await Hive.openBox<String>('appBox'); // it must be a Box<String>.
    final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
    await jsonCache.refresh(key, jsonData);
    Timer(Duration(seconds: 60), () {
      CacheDataManager.clearCachedData(key: key);
    });
  }

  static Future<Map<String, dynamic>?> getCachedData({required String key}) async {
    final box = await Hive.openBox<String>('appBox'); // it must be a Box<String>.
    final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
    final Map<String, dynamic>? jsonData = await jsonCache.value(key);
    return jsonData;
  }

  static clearCachedData({String? key}) async {
    final box = await Hive.openBox<String>('appBox'); // it must be a Box<String>.
    final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
    key != null ? jsonCache.remove(key) : jsonCache.clear();
  }
}