// 🟢 이벤트 정의
import 'package:equatable/equatable.dart';

abstract class RoundListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// ✅ 전체 데이터 로드
class LoadAllLottoNumbersEvent extends RoundListEvent {}

// ✅ 월별 필터 이벤트
class FilterByMonthEvent extends RoundListEvent {
  final int? year;
  final int? month;

  FilterByMonthEvent({this.year, this.month}); // ✅ null 허용

  @override
  List<Object?> get props => [year, month];
}

// ✅ 필터 해제 이벤트
class ClearFilterEvent extends RoundListEvent {}