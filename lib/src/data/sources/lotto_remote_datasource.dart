import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lotto_remote_model.dart';

class LottoRemoteDataSource {
  final FirebaseFirestore _firestore;

  LottoRemoteDataSource(this._firestore);

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
}
