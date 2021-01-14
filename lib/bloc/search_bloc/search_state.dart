part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchOptionLoadedState extends SearchState {
  final String topic;
  final List<News> newsList;
  SearchOptionLoadedState({@required this.topic, @required this.newsList});
}

class SearchErrorState extends SearchState {
  final String topic;
  SearchErrorState({@required this.topic});
}
