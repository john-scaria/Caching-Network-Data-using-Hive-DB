import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:network_caching_hive/models/models.dart';
import 'package:webfeed/webfeed.dart';

import 'network_client.dart';

class NetworkRepository {
  final NetworkClient networkClient;
  NetworkRepository({@required this.networkClient});

  Future<String> getRssString(String topic) async =>
      await networkClient.fetchRssString(topic);

  List<News> rssParser(String rssString) {
    final newsRss = RssFeed.parse(rssString);
    return List.generate(
        newsRss.items.length, (index) => News.fromRss(index, newsRss.items));
  }

  Future<String> getHomeRssString() async =>
      await networkClient.fetchHomeRssString();
}
