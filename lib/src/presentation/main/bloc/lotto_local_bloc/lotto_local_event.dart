import 'package:equatable/equatable.dart';

// 🟢 이벤트 정의
abstract class LottoLocalEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// ✅ 특정 회차 로드
class LoadLottoNumbersEvent extends LottoLocalEvent {
  final int round;

  LoadLottoNumbersEvent(this.round);

  @override
  List<Object?> get props => [round];
}

// ✅ 전체 데이터 로드
class LoadAllLottoNumbersEvent extends LottoLocalEvent {}

// ✅ 로또 번호 생성
class GenerateLottoNumbersEvent extends LottoLocalEvent {
  final int round;
  final String date;
  final List<int> numbers;
  final String recommendReason;
  final String dailyTip;

  GenerateLottoNumbersEvent({
    required this.round,
    required this.date,
    required this.numbers,
    required this.recommendReason,
    required this.dailyTip,
  });

  @override
  List<Object?> get props => [round, date, numbers, recommendReason, dailyTip];
}

// ✅ 당첨번호 업데이트
class UpdateWinningNumbersEvent extends LottoLocalEvent {
  final int round;
  final List<int> winningNumbers;

  UpdateWinningNumbersEvent({
    required this.round,
    required this.winningNumbers,
  });

  @override
  List<Object?> get props => [round, winningNumbers];
}