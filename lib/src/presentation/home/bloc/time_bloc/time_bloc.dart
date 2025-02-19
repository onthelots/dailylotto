import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_event.dart';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeBloc extends Bloc<TimeEvent, TimeState> {
  TimeBloc() : super(TimeState.fromPeriod(_getCurrentPeriod())) {
    on<RefreshTimeEvent>((event, emit) {
      emit(TimeState.fromPeriod(_getCurrentPeriod()));
    });
  }

  // 현재 시각 불러오기
  static TimePeriod _getCurrentPeriod() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return TimePeriod.morning;
    } else if (hour >= 12 && hour < 18) {
      return TimePeriod.lunch;
    } else {
      return TimePeriod.evening;
    }
  }
}