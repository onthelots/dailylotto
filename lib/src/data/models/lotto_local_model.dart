import 'package:hive/hive.dart';
part 'lotto_local_model.g.dart'; // 자동 생성된 파일

@HiveType(typeId: 0)
class LottoLocalModel {
  @HiveField(0)
  int round; // 회차 번호

  @HiveField(1)
  List<LottoEntry> entries; // 해당 회차에서 추천된 번호 리스트

  @HiveField(2)
  List<int>? winningNumbers; // 해당 회차 당첨번호

  LottoLocalModel({
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

  @HiveField(5)
  bool isDefault;  // 기본값인지 여부를 체크하는 필드. 즉 오늘 날짜에 생성한 번호가 없을 경우 true로 설정되므로, 이를 활용하여 분기처리가 가능함

  LottoEntry({
    required this.date,
    required this.numbers,
    required this.recommendReason,
    required this.dailyTip,
    this.result,
    this.isDefault = false, // 기본값 플래그
  });
}