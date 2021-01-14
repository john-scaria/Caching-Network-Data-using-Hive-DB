import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:network_caching_hive/repositories/repositories.dart';

part 'dark_event.dart';
part 'dark_state.dart';

class DarkBloc extends Bloc<DarkEvent, DarkState> {
  final DarkRepository darkRepository;
  DarkBloc({@required this.darkRepository})
      : super(DarkState(isDark: darkRepository.getDark()));

  @override
  Stream<DarkState> mapEventToState(
    DarkEvent event,
  ) async* {
    if (event is DarkToggleEvent) {
      try {
        bool _darkVerify = await darkRepository.addDark(event.isDark);
        if (_darkVerify) {
          yield DarkState(isDark: darkRepository.getDark());
        }
      } catch (_) {}
    }
  }
}
