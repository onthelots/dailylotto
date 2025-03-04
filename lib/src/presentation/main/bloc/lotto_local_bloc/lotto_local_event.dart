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
  final int bonusNumber;

  UpdateWinningNumbersEvent({
    required this.round,
    required this.winningNumbers,
    required this.bonusNumber,
  });

  @override
  List<Object?> get props => [round, winningNumbers, bonusNumber];
}

// ✅ 더미데이터 추가
class CreateDummyRoundData extends LottoLocalEvent {
  final int round;

  CreateDummyRoundData(this.round);

  @override
  List<Object?> get props => [round];
}