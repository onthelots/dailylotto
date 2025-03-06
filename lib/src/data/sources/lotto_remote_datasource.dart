import 'package:cloud_firestore/cloud_firestore.dart';
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

  // 사용자가 매번 번호를 생성할 때 마다 Firestore에 저장하는 로직
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
}
