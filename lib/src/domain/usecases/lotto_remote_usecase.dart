import 'package:dailylotto/src/data/models/lotto_remote_model.dart';
import 'package:dailylotto/src/data/models/lotto_stats_model.dart';
import 'package:dailylotto/src/domain/repositories/lotto_remote_repository.dart';

class LottoRemoteUseCase {
  final LottoRemoteRepository repository;

  LottoRemoteUseCase({required this.repository});

  // 최근 회차 데이터 불러오기 -> Call 함수
  Stream<LottoRemoteModel> call() {
    return repository.getLatestRound();
  }

  // firebase 업로드
  Future<void> saveLottoEntry({required List<int> numbers, required int currentRound}) async {
    return repository.saveLottoEntry(numbers, currentRound);
  }

  // 회차별 데이터 가져오기
  Future<LottoStatsModel> getRoundData(int roundId) async {
    return repository.getRoundData(roundId);
  }
}
