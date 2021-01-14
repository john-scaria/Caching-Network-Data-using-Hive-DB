import 'package:network_caching_hive/models/models.dart';

class TimelineArranger {
  static List<News> arrangeInTimeline(List<News> list) {
    if (list.elementAt(0).pDate == null) {
      return [];
    }
    list.sort((a, b) => b.pDate.compareTo(a.pDate));
    return list;
  }
}
