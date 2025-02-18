import 'dart:math';

import 'package:dailylotto/src/domain/repositories/lotto_local_repository.dart';

import '../../data/models/lotto_round.dart';
import '../../data/sources/lotto_local_datasource.dart';

class LottoUseCase {
  final LottoRepository lottoLocalRepository;


  LottoUseCase(this.lottoLocalRepository);

  // 매일 1회 번호 생성
  Future<void> generateDailyLottoNumbers(int round, String date) async {
    final currentRound = lottoLocalRepository.getLottoRound(round);

    // 매일 새롭게 생성되는 로또 데이터
    final newEntry = LottoEntry(
        date: date,
        numbers: generateRandomLottoNumbers(),
        recommendReason: "AI 추천 이유 더미 데이터",
        dailyTip: "오늘의 조언 더미 데이터"
    );

    // 현재 회차가 존재할 경우
    if (currentRound != null) {
      currentRound.entries.add(newEntry); // 현재 회차 생성 번호 List 내 할당
      await lottoLocalRepository.saveLottoRound(currentRound); // HIVE 내 저장 (업데이트)
    }
  }

  // 현재 회차 가져오기
  int getCurrentRound() {
    return DateTime.now().weekday == DateTime.sunday ? getNextRound() : getLatestRound();
  }

  // 마지막 회차 가져오기
  int getLatestRound() {
    final allRounds = lottoLocalRepository.getAllRounds();
    return allRounds.isEmpty ? 1000 : allRounds.last.round;
  }

  // 다음 회차 가져오기
  int getNextRound() {
    return getLatestRound() + 1;
  }

  // 더미데이터 (로또번호 랜덤 생성)
  List<int> generateRandomLottoNumbers() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(45) + 1);
  }
}
