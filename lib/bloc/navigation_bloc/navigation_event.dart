part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {}

class NavigationItemTappedEvent extends NavigationEvent {
  final String title;
  final int selectedIndex;
  NavigationItemTappedEvent(
      {@required this.title, @required this.selectedIndex});
}

class NavigationHomeTappedEvent extends NavigationEvent {}
