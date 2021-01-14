import 'package:network_caching_hive/repositories/db_client.dart';

import 'package:meta/meta.dart';

class DbRepository {
  final DbClient dbClient;
  DbRepository({@required this.dbClient});

  Future<bool> addTopic(String topic) async =>
      await dbClient.insertTopic(topic);

  List<String> getAllTopics() => dbClient.readAllTopics();

  Future<bool> removeTopic(String topic) async =>
      await dbClient.deleteTopic(topic);
}
