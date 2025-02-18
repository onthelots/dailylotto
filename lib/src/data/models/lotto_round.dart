import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class LottoRound {
  @HiveField(0)
  int round; // 회차 번호

  @HiveField(1)
  List<LottoEntry> entries; // 해당 회차에서 추천된 번호 리스트

  @HiveField(2)
  List<int>? winningNumbers; // 해당 회차 당첨번호

  LottoRound({
    required this.round,
    required this.entries,
    this.winningNumbers,
  });
}

@HiveType(typeId: 1)
class LottoEntry {
  @HiveField(0)
  String date; // 날짜 (YYYY-MM-DD 형식)

  @HiveField(1)
  List<int> numbers; // 6개의 번호

  @HiveField(2)
  String recommendReason; // AI 추천 이유

  @HiveField(3)
  String dailyTip; // AI 오늘의 조언

  @HiveField(4)
  String? result; // '당첨', '낙첨', '예정'

  LottoEntry({
    required this.date,
    required this.numbers,
    required this.recommendReason,
    required this.dailyTip,
    this.result,
  });
}