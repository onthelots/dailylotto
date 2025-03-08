import 'package:equatable/equatable.dart';

// 🟢 이벤트 정의
abstract class WeeklyLottoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// ✅ 이번 회차 로드
class LoadWeeklyLottoEvent extends WeeklyLottoEvent {
  final int round;

  LoadWeeklyLottoEvent({required this.round});

  @override
  List<Object?> get props => [round];
}