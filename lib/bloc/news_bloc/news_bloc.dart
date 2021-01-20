import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:network_caching_hive/models/models.dart';
import 'package:network_caching_hive/repositories/repositories.dart';
import 'package:network_caching_hive/utils/utils.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final CacheRepository cacheRepository;
  final NetworkRepository networkRepository;
  final DataConnectionChecker dataConnectionChecker;
  NewsBloc({
    @required this.cacheRepository,
    @required this.networkRepository,
    @required this.dataConnectionChecker,
  }) : super(NewsInitial(
          removed: cacheRepository.removeAllCache(StringData.homeKey),
        ));

  final String homeKey = StringData.homeKey;
  var listner;

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    NewsState currentState = state;
    yield NewsLoading();
    if (event is NewsInitTriggerEvent && currentState is NewsInitial) {
      await currentState.removed;
      yield* _newsHomeMapping(homeKey);
    }
    if (event is NewsItemTappedEvent) {
      yield* _newsItemMapping(event);
    }
    if (event is NewsHomeTappedEvent) {
      yield* _newsHomeMapping(homeKey);
    }
    if (event is RefreshItemEvent) {
      yield* _newsItemRefreshMapping(event);
    }
    if (event is RefreshHomeEvent) {
      yield* _newsHomeRefreshMapping(homeKey);
    }
  }

  Stream<NewsState> _newsItemMapping(NewsItemTappedEvent event) async* {
    String _checkCache = await cacheRepository.getCache(event.topic);
    if (_checkCache == 'no_cache') {
      try {
        final String _rssData = await _getRssDataFromNetwork(event.topic);
        yield* _newsItemCacheCheckToResultMaker(event.topic, _rssData);
      } catch (_) {
        if (!(await dataConnectionChecker.hasConnection)) {
          yield NewsItemError(message: 'No Network !!', topic: event.topic);
        } else {
          yield NewsItemError(
              message: 'No News Available !!', topic: event.topic);
        }
      }
    } else {
      yield* _newsItemLoaderMaker(event.topic);
    }
  }

  Future<String> _getRssDataFromNetwork(String _eventTopic) async {
    final String _data = await networkRepository.getRssString(_eventTopic);
    return _data;
  }

  Future<List<News>> _itemListMaker(String _eventTopic) async {
    String _cache = await cacheRepository.getCache(_eventTopic);
    return TimelineArranger.arrangeInTimeline(
        networkRepository.rssParser(_cache));
  }

  Stream<NewsState> _newsItemLoaderMaker(String _eventTopic) async* {
    try {
      List<News> _newsList = await _itemListMaker(_eventTopic);
      yield NewsItemLoadedState(newsList: _newsList, topic: _eventTopic);
    } catch (_) {
      yield NewsItemError(message: 'No News Available !!', topic: _eventTopic);
    }
  }

  Stream<NewsState> _newsItemCacheCheckToResultMaker(
      String _eventTopic, String _data) async* {
    bool _cacheInserted = await cacheRepository.addCache(_eventTopic, _data);
    if (_cacheInserted) {
      yield* _newsItemLoaderMaker(_eventTopic);
    } else {
      yield NewsItemError(message: 'No News Available !!', topic: _eventTopic);
    }
  }

  Stream<NewsState> _newsItemRefreshMapping(RefreshItemEvent event) async* {
    final String _getCache = await cacheRepository.getCache(event.topic);
    if (_getCache != 'no_cache') {
      //Excluded if (_getCache != 'no_cache' || _getCache != null || _getCache.isNotEmpty)
      try {
        final String _rssData = await _getRssDataFromNetwork(event.topic);
        yield* _newsItemCacheCheckToResultMaker(event.topic, _rssData);
      } catch (e) {
        yield* _newsItemCacheCheckToResultMaker(event.topic, _getCache);
      }
    } else {
      try {
        final String _rssData = await _getRssDataFromNetwork(event.topic);
        yield* _newsItemCacheCheckToResultMaker(event.topic, _rssData);
      } catch (_) {
        if (!(await dataConnectionChecker.hasConnection)) {
          yield NewsItemError(message: 'No Network !!', topic: event.topic);
        } else {
          yield NewsItemError(
              message: 'No News Available !!', topic: event.topic);
        }
      }
    }
    /* else {
      yield NewsItemError(message: 'No News Available !!', topic: event.topic);
    } */
  }

  Stream<NewsState> _newsHomeMapping(String _homeKey) async* {
    final String _checkHomeCache = await cacheRepository.getHomeCache(_homeKey);
    if (_checkHomeCache == 'no_cache') {
      try {
        final String _homeRssData = await _getHomeRssDataFromNetwork();
        yield* _newsHomeCacheCheckToResultMaker(_homeKey, _homeRssData);
      } catch (e) {
        if (!(await dataConnectionChecker.hasConnection)) {
          yield NewsHomeError(message: 'No Network !!');
        } else {
          yield NewsHomeError(message: 'No News Available !!');
        }
      }
    } else {
      yield* _newsHomeLoaderMaker(_homeKey);
    }
  }

  Future<String> _getHomeRssDataFromNetwork() async {
    final String _homeData = await networkRepository.getHomeRssString();
    return _homeData;
  }

  Future<List<News>> _homeListMaker(String _homeKey) async {
    String _homeCache = await cacheRepository.getHomeCache(_homeKey);
    return TimelineArranger.arrangeInTimeline(
        networkRepository.rssParser(_homeCache));
  }

  Stream<NewsState> _newsHomeLoaderMaker(String _homeKey) async* {
    try {
      List<News> _homeNewsList = await _homeListMaker(_homeKey);
      yield NewsHomeLoadedState(newsList: _homeNewsList);
    } catch (_) {
      NewsHomeError(message: 'No News Available !!');
    }
  }

  Stream<NewsState> _newsHomeCacheCheckToResultMaker(
      String _homeKey, String _homeData) async* {
    bool _homeCacheInserted =
        await cacheRepository.addHomeCache(_homeKey, _homeData);
    if (_homeCacheInserted) {
      yield* _newsHomeLoaderMaker(_homeKey);
    } else {
      yield NewsHomeError(message: 'No News Available !!');
    }
  }

  Stream<NewsState> _newsHomeRefreshMapping(String _homeKey) async* {
    final String _getHomeCache = await cacheRepository.getHomeCache(_homeKey);
    if (_getHomeCache != 'no_cache') {
      /*Excluded *if (_getHomeCache != 'no_cache' &&
        _getHomeCache != null &&
        _getHomeCache.isNotEmpty)*/
      try {
        final String _homeRssData = await _getHomeRssDataFromNetwork();
        yield* _newsHomeCacheCheckToResultMaker(_homeKey, _homeRssData);
      } catch (e) {
        yield* _newsHomeCacheCheckToResultMaker(_homeKey, _getHomeCache);
      }
    } else {
      try {
        final String _homeRssData = await _getHomeRssDataFromNetwork();
        yield* _newsHomeCacheCheckToResultMaker(_homeKey, _homeRssData);
      } catch (e) {
        if (!(await dataConnectionChecker.hasConnection)) {
          yield NewsHomeError(message: 'No Network !!');
        } else {
          yield NewsHomeError(message: 'No News Available !!');
        }
      }
      //yield NewsHomeError(message: 'No News Available !!');
    }
  }
}
