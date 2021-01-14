import 'package:meta/meta.dart';
import 'package:network_caching_hive/repositories/cache_client.dart';

class CacheRepository {
  final CacheClient cacheClient;
  CacheRepository({@required this.cacheClient});

  Future<bool> addCache(String topic, String cache) async =>
      await cacheClient.insertCache(topic, cache);

  Future<String> getCache(String topic) async =>
      await cacheClient.readCache(topic);

  Future<bool> removeAllCache(String homeKey) async =>
      await cacheClient.deleteAllCache(homeKey);

  Future<bool> addHomeCache(String _key, String _cache) async =>
      await cacheClient.insertHomeCache(_key, _cache);

  Future<String> getHomeCache(String _key) async =>
      await cacheClient.getHomeCache(_key);
}
