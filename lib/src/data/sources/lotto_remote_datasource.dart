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

    final docRef = FirebaseFirestore.instance.collection("dailyNumbers").doc("$currentRound");

    // 트랜잭션 시작
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(docRef);

      if (!docSnapshot.exists) {
        // 문서가 존재하지 않으면 새로 생성 -> 매주 토요일 21:00가 되면 갱신되므로 새롭게 생성됨.
        transaction.set(docRef, {
          "numbers": FieldValue.arrayUnion([
            {
              "createdAt": timestamp,
              "values": numbers,
            }
          ]),
          "totalGenerated": 1, // 첫 번째 번호 생성시 1로 시작
          "numberCounts": _initializeNumberCounts(), // 각 번호별 초기 값 설정
        });
      } else {
        // 문서가 존재하면 업데이트
        // 현재 "totalGenerated" 값과 "numberCounts" 값을 가져옴
        final data = docSnapshot.data()!;
        final totalGenerated = data["totalGenerated"] ?? 0;
        final numberCounts = Map<String, dynamic>.from(data["numberCounts"] ?? {});

        // 번호 추가
        transaction.update(docRef, {
          "numbers": FieldValue.arrayUnion([
            {
              "createdAt": timestamp,
              "values": numbers,
            }
          ]),
          "totalGenerated": totalGenerated + 1, // 번호 생성 수 증가
          "numberCounts": _updateNumberCounts(numberCounts, numbers), // 각 번호 카운트 업데이트
        });
      }
    });
  }

  // 번호 카운트 초기화 (예: 1~45 번호)
  Map<String, int> _initializeNumberCounts() {
    final Map<String, int> initialCounts = {};
    for (int i = 1; i <= 45; i++) {
      initialCounts[i.toString()] = 0; // 각 번호의 카운트를 0으로 초기화
    }
    return initialCounts;
  }

  // 번호 카운트 업데이트
  Map<String, dynamic> _updateNumberCounts(Map<String, dynamic> currentCounts, List<int> numbers) {
    final updatedCounts = Map<String, dynamic>.from(currentCounts);

    for (var number in numbers) {
      final count = updatedCounts[number.toString()] ?? 0;
      updatedCounts[number.toString()] = count + 1; // 해당 번호의 카운트 증가
    }
    return updatedCounts;
  }
}
