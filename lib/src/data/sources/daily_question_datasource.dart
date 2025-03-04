import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_question_model.dart';

class DailyQuestionFirebaseDataSource {
  final FirebaseFirestore firestore;

  DailyQuestionFirebaseDataSource({required this.firestore});

  Future<DailyQuestionModel?> fetchDailyQuestion() async {
    final randomValue = Random().nextDouble(); // 0과 1 사이 난수 생성

    // randomValue 이상인 문서를 오름차순 정렬해서 1개 조회
    Query query = firestore
        .collection('daily_questions')
        .where('randomValue', isGreaterThanOrEqualTo: randomValue)
        .orderBy('randomValue')
        .limit(1);

    QuerySnapshot snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      return DailyQuestionModel.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    } else {
      // 결과가 없으면, 반대 조건으로 내림차순 정렬하여 1개 조회
      QuerySnapshot fallbackSnapshot = await firestore
          .collection('daily_questions')
          .where('randomValue', isLessThan: randomValue)
          .orderBy('randomValue', descending: true)
          .limit(1)
          .get();

      if (fallbackSnapshot.docs.isNotEmpty) {
        return DailyQuestionModel.fromMap(fallbackSnapshot.docs.first.data() as Map<String, dynamic>);
      }
    }
    return null;
  }
}