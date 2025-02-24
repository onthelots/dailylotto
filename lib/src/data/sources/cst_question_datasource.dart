import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailylotto/src/data/models/cst_question_model.dart';

class QuestionDataSource {
  final CollectionReference _cstquestions = FirebaseFirestore.instance.collection('cstquestions');

  Future<List<CSTQuestion>> getCSTQuestions() async {
    final snapshot = await _cstquestions.get();
    return snapshot.docs
        .map((doc) => CSTQuestion.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}