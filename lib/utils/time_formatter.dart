import 'package:intl/intl.dart';

class TimeFormatter {
  static String toUnderStandable(DateTime dateTime) {
    if (dateTime == null) {
      return 'Time not Available';
    }
    if (DateFormat.yMMMd().format(dateTime) ==
        DateFormat.yMMMd().format(DateTime.now())) {
      var agoTime = DateFormat.jm().format(dateTime);
      return 'Today $agoTime';
    }
    return '${DateFormat.yMMMd().add_jm().format(dateTime)}';
  }
}
