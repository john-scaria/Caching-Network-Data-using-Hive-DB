import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:network_caching_hive/utils/utils.dart';

class DarkClient {
  final Box<bool> dBox;
  DarkClient({@required this.dBox});

  final _darkKey = StringData.darkKey;

  Future<bool> insertDark(bool _isDark) async {
    try {
      await dBox.put(_darkKey, _isDark);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool readDark() {
    try {
      bool _isDark = dBox.get(_darkKey, defaultValue: false);
      return _isDark;
    } catch (_) {
      return false;
    }
  }
}
