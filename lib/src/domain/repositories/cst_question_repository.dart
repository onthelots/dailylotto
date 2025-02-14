import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailylotto/src/data/models/cst_question_model.dart';
import 'package:dailylotto/src/data/sources/cst_question_datasource.dart';

class CstQuestionRepository{
  final QuestionDataSource _dataSource;

  CstQuestionRepository(this._dataSource);

  Future<List<CSTQuestion>> getThreeRandomQuestions() async {
    final cstQuestionList = await _dataSource.getCSTQuestions();
    cstQuestionList.shuffle();
    return cstQuestionList.sublist(0, 3);
  }
}