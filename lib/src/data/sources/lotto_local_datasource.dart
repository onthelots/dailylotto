import 'package:hive_flutter/hive_flutter.dart';
import '../models/lotto_round.dart';

class LottoLocalDataSource {
  final Box<LottoRound> _box;

  LottoLocalDataSource(this._box);

  // 번호 생성 후 저장 (이번주 회차)
  Future<void> saveLottoRound(LottoRound round) async {
    await _box.put(round.round, round);
  }

  // 특정 회차 데이터 가져오기
  LottoRound? getLottoRound(int round) {
    return _box.get(round);
  }

  // 모든 회차 데이터 가져오기
  List<LottoRound> getAllRounds() {
    return _box.values.toList();
  }

  // 당첨번호 업데이트
  Future<void> updateWinningNumbers(int round, List<int> winningNumbers) async {
    final lottoRound = _box.get(round);
    if (lottoRound != null) {
      for (var entry in lottoRound.entries) {
        final isWinner = entry.numbers.toSet().containsAll(winningNumbers);
        entry.result = isWinner ? "당첨 🎉" : "낙첨 ❌";
      }
      await _box.put(round, lottoRound);
    }
  }

  // 새로운 회차 추가
  Future<void> createNewRound(int newRound) async {
    final newLottoRound = LottoRound(round: newRound, entries: []);
    await _box.put(newRound, newLottoRound);
  }
}
