import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_event.dart';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeBloc extends Bloc<TimeEvent, TimeState> {
  TimeBloc() : super(TimeState.fromPeriod(_getCurrentPeriod(), _getCurrentDate())) {
    on<RefreshTimeEvent>((event, emit) {
      // RefreshTimeEvent 발생 시, 현재 날짜로 새로운 TimeState를 emit
      emit(TimeState.fromPeriod(_getCurrentPeriod(), _getCurrentDate()));
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

  // 현재 날짜를 "yyyy년 MM월 dd일" 형식으로 반환
  static String _getCurrentDate() {
    final now = DateTime.now();
    return "${now.year}년 ${now.month.toString().padLeft(2, '0')}월 ${now.day.toString().padLeft(2, '0')}일";
  }
}