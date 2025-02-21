import 'package:dailylotto/src/domain/repositories/lotto_local_repository.dart';
import '../../data/models/lotto_local_model.dart';

class LottoLocalUseCase {
  final LottoLocalRepository repository;

  LottoLocalUseCase({required this.repository});

  // 번호 생성 후 저장
  Future<void> saveLottoRound(LottoLocalModel round) {
    return repository.saveLottoRound(round);
  }

  // 특정 회차 데이터 가져오기
  LottoLocalModel? getLottoRound(int round) {
    return repository.getLottoRound(round);
  }

  // 모든 회차 데이터 가져오기
  List<LottoLocalModel> getAllRounds() {
    return repository.getAllRounds();
  }

  // 당첨번호 업데이트
  Future<void> updateWinningNumbers(int round, List<int> winningNumbers, int bonusNumber) {
    return repository.updateWinningNumbers(round, winningNumbers, bonusNumber);
  }

  // 새로운 회차 추가
  Future<void> createNewRound(int newRound) {
    return repository.createNewRound(newRound);
  }

  // 오늘 날짜에 대한 로또 번호가 이미 생성된 상태인지 확인
  Future<bool> isLottoNumbersAlreadyGenerated(int round, String date) async {
    final roundData = await repository.getLottoRound(round);
    if (roundData != null) {
      return roundData.entries.any((entry) => entry.date == date);
    }
    return false;
  }
}

