import '../../data/models/lotto_round.dart';
import '../../data/sources/lotto_local_datasource.dart';

class LottoRepository {
  final LottoLocalDataSource localDataSource;

  LottoRepository(this.localDataSource);

  // 로또 생성 시, HIVE 저장 (현재 회차)
  Future<void> saveLottoRound(LottoRound round) async {
    await localDataSource.saveLottoRound(round);
  }

  // 새로운 회차 HIVE 생성
  Future<void> createNewRound(int newRound) async {
    await localDataSource.createNewRound(newRound);
  }

  // 현재 회차 가져오기
  LottoRound? getLottoRound(int round) {
    return localDataSource.getLottoRound(round);
  }

  // 전체 회차 가져오기
  List<LottoRound> getAllRounds() {
    return localDataSource.getAllRounds();
  }
}