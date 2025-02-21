import 'package:hive_flutter/hive_flutter.dart';
import '../models/lotto_local_model.dart';

class LottoLocalDataSource {
  final Box<LottoLocalModel> _box;

  LottoLocalDataSource(this._box);

  // 번호 생성 후 저장 (이번주 회차)
  Future<void> saveLottoRound(LottoLocalModel round) async {
    try {
      await _box.put(round.round, round);  // 저장
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
    }

    await _box.put(round, lottoRound); // 업데이트된 데이터 저장
  }


  // 새로운 회차 추가
  Future<void> createNewRound(int newRound) async {

    // 새로운 회차가 이미 존재하는지 여부 확인
    if (!_box.containsKey(newRound)) {

      // 없다면, entries가 빈 상황으로 저장
      final newLottoRound = LottoLocalModel(round: newRound, entries: []);
      await _box.put(newRound, newLottoRound);
    }
  }
}
