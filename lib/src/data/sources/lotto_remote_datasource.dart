import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailylotto/src/data/models/lotto_stats_model.dart';
import '../models/lotto_remote_model.dart';

class LottoRemoteDataSource {
  final FirebaseFirestore _firestore;

  LottoRemoteDataSource(this._firestore);

  // 최근회차 불러오기
  Stream<LottoRemoteModel> getLatestRound() {
    return _firestore.collection('lotto').doc('latestRound').snapshots().map(
          (snapshot) {
        if (snapshot.exists) {
          return LottoRemoteModel.fromMap(snapshot.data()!);
        } else {
          throw Exception("latestRound 데이터 없음");
        }
      },
    );
  }

  // 생성번호 저장
  Future<void> saveLottoEntry(List<int> numbers, int currentRound) async {
    final timestamp = DateTime.now().toIso8601String(); // 생성 시간

    final docRef = FirebaseFirestore.instance.collection("dailyNumbers").doc(
        "${currentRound}");

    await docRef.set({
      "numbers": FieldValue.arrayUnion([
        {
          "createdAt": timestamp,
          "values": numbers,
        }
      ])
    }, SetOptions(merge: true));
  }

  // 최근회차 당첨결과 불러오기 (1~5등)
  Future<LottoStatsModel> getRoundData(int roundId) async {
    final snapshot = await _firestore.collection('lotto').doc("$roundId").get();
    if (snapshot.exists) {
      return LottoStatsModel.fromMap(snapshot.data()!);
    } else {
      throw Exception("$roundId 데이터 없음");
    }
  }
}
