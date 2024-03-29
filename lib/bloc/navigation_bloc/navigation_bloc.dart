import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc()
      : super(NavigationInitial(
          title: 'Top Stories',
        ));

  @override
  Stream<NavigationState> mapEventToState(
    NavigationEvent event,
  ) async* {
    //yield NavigationLoading();
    if (event is NavigationItemTappedEvent) {
      yield NavigationItemSelectedState(
        title: event.title,
        selectedIndex: event.selectedIndex,
      );
    }
    if (event is NavigationHomeTappedEvent) {
      yield NavigationHomeSelectedState(
        title: 'Top Stories',
      );
    }
  }
}
