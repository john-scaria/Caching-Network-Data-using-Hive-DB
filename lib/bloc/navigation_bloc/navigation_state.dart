part of 'navigation_bloc.dart';

@immutable
abstract class NavigationState {}

class NavigationInitial extends NavigationState {
  final String title;
  NavigationInitial({
    @required this.title,
  });
}

class NavigationItemSelectedState extends NavigationState {
  final String title;
  final int selectedIndex;
  NavigationItemSelectedState({
    @required this.title,
    @required this.selectedIndex,
  });
}

//class NavigationLoading extends NavigationState {}

class NavigationHomeSelectedState extends NavigationState {
  final String title;
  NavigationHomeSelectedState({
    @required this.title,
  });
}
