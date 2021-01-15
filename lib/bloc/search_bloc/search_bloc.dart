import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:network_caching_hive/models/models.dart';
import 'package:network_caching_hive/repositories/repositories.dart';
import 'package:network_caching_hive/utils/utils.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({@required this.networkRepository, @required this.dbRepository})
      : super(SearchInitial());

  final NetworkRepository networkRepository;
  final DbRepository dbRepository;
  bool isFound = false;

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchTextEnteredEvent) {
      yield SearchLoading();
      yield* _searchMapping(event);
    }
    if (event is SearchResetEvent) {
      yield SearchInitial();
    }
  }

  Stream<SearchState> _searchMapping(SearchTextEnteredEvent event) async* {
    try {
      final List<String> _allTopics = dbRepository.getAllTopics();
      isFound = _allTopics.contains(event.topic) ? true : false;
      final String _searchRssData = await _getRssDataFromNetwork(event.topic);
      List<News> _searchNewsList = TimelineArranger.arrangeInTimeline(
          networkRepository.rssParser(_searchRssData));
      yield _searchNewsList.length != 0
          ? SearchOptionLoadedState(
              topic: event.topic, newsList: _searchNewsList, isFound: isFound)
          : SearchErrorState(topic: event.topic);
    } catch (e) {
      yield SearchErrorState(topic: event.topic);
    }
  }

  Future<String> _getRssDataFromNetwork(String _eventTopic) async {
    final String _data = await networkRepository.getRssString(_eventTopic);
    return _data;
  }
}
