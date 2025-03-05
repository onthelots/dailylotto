import 'package:dailylotto/src/data/models/lotto_remote_model.dart';
import 'package:dailylotto/src/data/sources/lotto_remote_datasource.dart';

class LottoRemoteRepository {
  final LottoRemoteDataSource dataSource;

  LottoRemoteRepository({required this.dataSource});

  Stream<LottoRemoteModel> getLatestRound() {
    return dataSource.getLatestRound();
  }

  Future<void> saveLottoEntry(List<int> numbers, int currentRound) async {
    return dataSource.saveLottoEntry(numbers, currentRound);
  }
}
