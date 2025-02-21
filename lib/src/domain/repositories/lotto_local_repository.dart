import '../../data/models/lotto_local_model.dart';
import '../../data/sources/lotto_local_datasource.dart';

class LottoLocalRepository {
  final LottoLocalDataSource dataSource;

  LottoLocalRepository({required this.dataSource});

  // 번호 생성 후 저장
  Future<void> saveLottoRound(LottoLocalModel round) {
    return dataSource.saveLottoRound(round);
  }

  // 특정 회차 데이터 가져오기
  LottoLocalModel? getLottoRound(int round) {
    return dataSource.getLottoRound(round);
  }

  // 모든 회차 데이터 가져오기
  List<LottoLocalModel> getAllRounds() {
    return dataSource.getAllRounds();
  }

  // 당첨번호 업데이트
  Future<void> updateWinningNumbers(int round, List<int> winningNumbers, int bonusNumber) {
    return dataSource.updateWinningNumbers(round, winningNumbers, bonusNumber);
  }

  // 새로운 회차 추가
  Future<void> createNewRound(int newRound) {
    return dataSource.createNewRound(newRound);
  }
}
