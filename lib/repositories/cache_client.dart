import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class CacheClient {
  final LazyBox<String> tBox;
  final LazyBox<String> hBox;
  CacheClient({@required this.tBox, @required this.hBox});

  Future<bool> insertCache(String topic, String cache) async {
    try {
      await tBox.put(topic, cache);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> readCache(String topic) async {
    try {
      String _cache = await tBox.get(topic, defaultValue: 'no_cache');
      return _cache;
    } catch (e) {
      return 'no_cache';
    }
  }

  Future<bool> deleteAllCache(String _homeKey) async {
    try {
      for (var i = 0; i < tBox.length; i++) {
        await tBox.putAt(i, 'no_cache');
      }
      await hBox.put(_homeKey, 'no_cache');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> insertHomeCache(String _key, String _cache) async {
    try {
      await hBox.put(_key, _cache);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> getHomeCache(String _key) async {
    try {
      if (hBox.isEmpty) {
        await hBox.put(_key, 'no_cache');
      }
      String _cache = await hBox.get(_key, defaultValue: 'no_cache');
      return _cache;
    } catch (e) {
      return 'no_cache';
    }
  }
}
