import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:network_caching_hive/bloc/dark_bloc/dark_bloc.dart';
import 'package:network_caching_hive/bloc/news_bloc/news_bloc.dart';
import 'package:network_caching_hive/bloc/search_bloc/search_bloc.dart';
import 'package:network_caching_hive/utils/utils.dart';

import 'bloc/db_bloc/db_bloc.dart';
import 'bloc/navigation_bloc/navigation_bloc.dart';
import 'repositories/repositories.dart';
import 'screens/home_page.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DbRepository _dbRepository;
  CacheRepository _cacheRepository;
  NetworkRepository _networkRepository;
  DarkRepository _darkRepository;
  final String dbName = StringData.topicBoxName;
  final String homeDbName = StringData.homeBoxName;
  final String darkDbName = StringData.darkBoxName;

  @override
  void initState() {
    _dbRepository =
        DbRepository(dbClient: DbClient(tBox: Hive.lazyBox<String>(dbName)));
    _cacheRepository = CacheRepository(
        cacheClient: CacheClient(
            tBox: Hive.lazyBox<String>(dbName),
            hBox: Hive.lazyBox<String>(homeDbName)));
    _networkRepository = NetworkRepository(
        networkClient: NetworkClient(httpClient: http.Client()));
    _darkRepository = DarkRepository(
        darkClient: DarkClient(dBox: Hive.box<bool>(darkDbName)));
    super.initState();
  }

  @override
  void dispose() {
    Hive.lazyBox<String>(dbName).close();
    Hive.lazyBox<String>(homeDbName).close();
    Hive.box<bool>(darkDbName).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<DbBloc>(
        create: (context) => DbBloc(dbRepository: _dbRepository),
      ),
      BlocProvider<NavigationBloc>(
        create: (context) => NavigationBloc(),
      ),
      BlocProvider<NewsBloc>(
        create: (context) => NewsBloc(
          cacheRepository: _cacheRepository,
          networkRepository: _networkRepository,
        )..add(NewsInitTriggerEvent()),
      ),
      BlocProvider<SearchBloc>(
        create: (context) => SearchBloc(
          networkRepository: _networkRepository,
        ),
      ),
      BlocProvider<DarkBloc>(
        create: (context) => DarkBloc(
          darkRepository: _darkRepository,
        ),
      ),
    ], child: TheMaterial());
  }
}

class TheMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DarkBloc, DarkState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Caching in Hive',
          home: HomePage(),
          theme: state.isDark ? ThemeData.dark() : ThemeData.light(),
        );
      },
    );
  }
}
