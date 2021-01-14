import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:network_caching_hive/repositories/repositories.dart';

part 'db_event.dart';
part 'db_state.dart';

class DbBloc extends Bloc<DbEvent, DbState> {
  DbBloc({@required this.dbRepository})
      : super(DbInitial(topicList: dbRepository.getAllTopics()));

  final DbRepository dbRepository;

  @override
  Stream<DbState> mapEventToState(
    DbEvent event,
  ) async* {
    if (event is AddTopicDbEvent) {
      yield DbLoadingState();
      bool inserted = await dbRepository.addTopic(event.topic);
      yield inserted
          ? DbLoadedState(topicList: dbRepository.getAllTopics())
          : DbInsertErrorState(topicList: dbRepository.getAllTopics());
    }
    if (event is DeleteTopicDbEvent) {
      yield DbLoadingState();
      bool deleted = await dbRepository.removeTopic(event.topic);
      yield deleted
          ? DbLoadedState(topicList: dbRepository.getAllTopics())
          : DbDeleteErrorState(topicList: dbRepository.getAllTopics());
    }
  }
}
