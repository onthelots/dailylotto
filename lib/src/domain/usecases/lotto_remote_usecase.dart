import 'package:dailylotto/src/data/models/lotto_remote_model.dart';
import 'package:dailylotto/src/domain/repositories/lotto_remote_repository.dart';

class LottoRemoteUseCase {
  final LottoRemoteRepository repository;

  LottoRemoteUseCase({required this.repository});

  Stream<LottoRemoteModel> call() {
    return repository.getLatestRound();
  }
}
