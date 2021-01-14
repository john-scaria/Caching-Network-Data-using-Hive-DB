import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class DbClient {
  final LazyBox<String> tBox;
  DbClient({@required this.tBox});

  Future<bool> insertTopic(String topic) async {
    try {
      await tBox.put(topic, 'no_cache');
      return true;
    } catch (e) {
      return false;
    }
  }

  List<String> readAllTopics() {
    List<String> _topicList = [];
    for (var item in tBox.keys) {
      _topicList.add(item.toString());
    }
    print(tBox.keys.toList());
    return _topicList;
  }

  Future<bool> deleteTopic(String topic) async {
    try {
      await tBox.delete(topic);
      return true;
    } catch (e) {
      return false;
    }
  }
}
