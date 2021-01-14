import 'package:meta/meta.dart';
import 'package:webfeed/domain/rss_item.dart';

class News {
  final String title;
  final DateTime pDate;
  final String link;
  final String source;

  News(
      {@required this.title,
      @required this.pDate,
      @required this.link,
      @required this.source});

  factory News.fromRss(int index, List<RssItem> rss) {
    return News(
      title: rss.elementAt(index).title,
      pDate: rss.elementAt(index).pubDate,
      link: rss.elementAt(index).link,
      source: rss.elementAt(index).source.url,
    );
  }
}
