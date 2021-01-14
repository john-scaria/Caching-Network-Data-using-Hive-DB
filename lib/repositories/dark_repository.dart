import 'package:meta/meta.dart';
import 'package:network_caching_hive/repositories/dark_client.dart';

class DarkRepository {
  final DarkClient darkClient;
  DarkRepository({@required this.darkClient});

  Future<bool> addDark(bool isDark) async =>
      await darkClient.insertDark(isDark);

  bool getDark() => darkClient.readDark();
}
