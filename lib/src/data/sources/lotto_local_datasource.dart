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
  Future<void> updateWinningNumbers(int round, List<int> winningNumbers) async {
    final lottoRound = _box.get(round); // 특정 회차의 round 가져오기

    if (lottoRound == null) return;  // 회차가 없으면 리턴

      // 반복문을 통해, 특정 회차 데이터의 당첨/낙첨 여부 확인
      for (var entry in lottoRound.entries) {
        final isWinner = entry.numbers.toSet().containsAll(winningNumbers);
        entry.result = isWinner ? "당첨 🎉" : "낙첨 ❌";
      }
      // 이후, 저장
      await _box.put(round, lottoRound);

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
