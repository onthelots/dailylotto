import 'package:dailylotto/src/data/models/daily_question_model.dart';
import 'package:dailylotto/src/data/sources/daily_question_datasource.dart';

class DailyQuestionRepository {
  final DailyQuestionFirebaseDataSource dataSource;

  DailyQuestionRepository({required this.dataSource});

  Future<DailyQuestionModel?> fetchDailyQuestion() async {
    return await dataSource.fetchDailyQuestion();
  }
}
