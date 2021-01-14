part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchTextEnteredEvent extends SearchEvent {
  final String topic;
  SearchTextEnteredEvent({@required this.topic});
}
