import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:network_caching_hive/bloc_observer/bloc_observer.dart';
import 'package:network_caching_hive/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openLazyBox<String>(StringData.topicBoxName);
  await Hive.openLazyBox<String>(StringData.homeBoxName);
  await Hive.openBox<bool>(StringData.darkBoxName);
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}
