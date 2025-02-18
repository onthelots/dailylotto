import 'package:flutter_bloc/flutter_bloc.dart';

enum TimePeriod { morning, lunch, evening }

class TimeCubit extends Cubit<TimePeriod> {
  TimeCubit() : super(_getCurrentPeriod());

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

  void refreshTime() {
    emit(_getCurrentPeriod());
  }
}