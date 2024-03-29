part of 'news_bloc.dart';

@immutable
abstract class NewsState {}

class NewsInitial extends NewsState {
  final Future<bool> removed;
  NewsInitial({@required this.removed});
}

class NewsItemLoadedState extends NewsState {
  final List<News> newsList;
  final String topic;
  NewsItemLoadedState({@required this.newsList, @required this.topic});
}

class NewsHomeLoadedState extends NewsState {
  final List<News> newsList;
  NewsHomeLoadedState({@required this.newsList});
}

class NewsLoading extends NewsState {}

class NewsItemError extends NewsState {
  final String message;
  final String topic;
  NewsItemError({@required this.message, @required this.topic});
}

class NewsHomeError extends NewsState {
  final String message;
  NewsHomeError({@required this.message});
}
