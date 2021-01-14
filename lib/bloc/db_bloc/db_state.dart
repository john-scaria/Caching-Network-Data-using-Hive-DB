part of 'db_bloc.dart';

@immutable
abstract class DbState {}

class DbInitial extends DbState {
  final List<String> topicList;
  DbInitial({@required this.topicList});
}

class DbLoadingState extends DbState {}

class DbLoadedState extends DbState {
  final List<String> topicList;
  DbLoadedState({@required this.topicList});
}

class DbInsertErrorState extends DbState {
  final List<String> topicList;
  DbInsertErrorState({@required this.topicList});
}

class DbDeleteErrorState extends DbState {
  final List<String> topicList;
  DbDeleteErrorState({@required this.topicList});
}
