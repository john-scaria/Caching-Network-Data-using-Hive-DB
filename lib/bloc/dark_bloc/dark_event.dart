part of 'dark_bloc.dart';

@immutable
abstract class DarkEvent {}

class DarkToggleEvent extends DarkEvent {
  final bool isDark;
  DarkToggleEvent({@required this.isDark});
}
