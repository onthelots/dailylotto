import 'package:hive_flutter/hive_flutter.dart';
import '../models/lotto_local_model.dart';

class LottoLocalDataSource {
  final Box<LottoLocalModel> _box;

  LottoLocalDataSource(this._box);

  // 번호 생성 후 저장 (이번주 회차)
  Future<void> saveLottoRound(LottoLocalModel roundData) async {
    try {
      await _box.put(roundData.round, roundData);  // 저장
      print("saveLottoRound : 저장 완료");
    } catch (e) {
      print("saveLottoRound : 저장 중 오류 발생: ${e.toString()}");
      throw e;  // 예외 발생 시 에러 던지기
    }
  }

  // 특정 회차 데이터 가져오기
  LottoLocalModel? getLottoRound(int round) {
    return _box.get(round);
  }

  // 모든 회차 데이터 가져오기
  List<LottoLocalModel> getAllRounds() {
    return _box.values.toList();
  }

  // 당첨번호 업데이트
  Future<void> updateWinningNumbers(int round, List<int> winningNumbers, int bonusNumber) async {
    final lottoRound = _box.get(round);

    if (lottoRound == null) return;

    print("--- 지난 회차 $round 결과 업데이트 ---");
    for (var entry in lottoRound.entries) {
      final matchedNumbers = entry.numbers.where((num) => winningNumbers.contains(num)).length;
      final hasBonus = entry.numbers.contains(bonusNumber);

      // 당첨 등수 판별
      if (matchedNumbers == 6) {
        entry.result = "1등";
      } else if (matchedNumbers == 5 && hasBonus) {
        entry.result = "2등";
      } else if (matchedNumbers == 5) {
        entry.result = "3등";
      } else if (matchedNumbers == 4) {
        entry.result = "4등";
      } else if (matchedNumbers == 3) {
        entry.result = "5등";
      } else {
        entry.result = "낙첨";
      }

      print("날짜: ${entry.date}, 번호: ${entry.numbers}, 결과: ${entry.result}");
    }

    await _box.put(round, lottoRound); // 업데이트된 데이터 저장
    print("updateWinningNumbers: 회차 $round 업데이트 완료");
  }


  // 새로운 회차 추가
  Future<void> createNewRound(int newRound) async {

    // 새로운 회차가 이미 존재하는지 여부 확인
    if (!_box.containsKey(newRound)) {
      // 다가오는 토요일 날짜 계산
      final now = DateTime.now();
      final daysUntilSaturday = (DateTime.saturday - now.weekday) % 7;
      final nextSaturday = now.add(Duration(days: daysUntilSaturday == 0 ? 7 : daysUntilSaturday));

      // 없다면, entries가 빈 상황으로 저장
      final newLottoRound = LottoLocalModel(round: newRound, entries: [], timeStamp: nextSaturday);
      await _box.put(newRound, newLottoRound);
    }
  }

  // 더미데이터 추가
  Future<void> createDummyRoundLocalData(int round) async {
    if (!_box.containsKey(round)) {
      final now = DateTime.now();
      final daysUntilSaturday = (DateTime.saturday - now.weekday) % 7;
      final nextSaturday = now.add(Duration(days: daysUntilSaturday == 0 ? 7 : daysUntilSaturday));
      final newLottoRound = LottoLocalModel(round: round, entries:[
        LottoEntry(date: '2025-02-10', numbers: [2,5,7,15,25,38], recommendReason: '오늘은 2월 10일', dailyTip: '오늘은 2월 10일'),
        LottoEntry(date: '2025-02-12', numbers: [3,9,27,28,40,41], recommendReason: '오늘은 2월 12일', dailyTip: '오늘은 2월 12일'),
        LottoEntry(date: '2025-02-14', numbers: [3,7,9,27,28,38], recommendReason: '오늘은 2월 14일', dailyTip: '오늘은 2월 14일'),
      ], timeStamp: nextSaturday);
      await _box.put(round, newLottoRound);
    }
  }
}
