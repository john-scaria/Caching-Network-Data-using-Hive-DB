part of 'db_bloc.dart';

@immutable
abstract class DbEvent {}

class AddTopicDbEvent extends DbEvent {
  final String topic;
  AddTopicDbEvent({@required this.topic});
}

class DeleteTopicDbEvent extends DbEvent {
  final String topic;
  DeleteTopicDbEvent({@required this.topic});
}
