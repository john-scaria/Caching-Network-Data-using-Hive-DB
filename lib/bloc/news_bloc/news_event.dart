part of 'news_bloc.dart';

@immutable
abstract class NewsEvent {}

class NewsItemTappedEvent extends NewsEvent {
  final String topic;
  NewsItemTappedEvent({@required this.topic});
}

class NewsHomeTappedEvent extends NewsEvent {}

class NewsInitTriggerEvent extends NewsEvent {}

class RefreshItemEvent extends NewsEvent {
  final String topic;
  RefreshItemEvent({@required this.topic});
}

class RefreshHomeEvent extends NewsEvent {}
