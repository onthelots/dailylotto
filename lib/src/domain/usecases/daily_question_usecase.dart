import 'package:dailylotto/src/data/models/daily_question_model.dart';
import 'package:dailylotto/src/domain/repositories/daily_question_repository.dart';

class DailyQuestionUseCase {
  final DailyQuestionRepository repository;

  DailyQuestionUseCase({required this.repository});

  Future<DailyQuestionModel?> call() async {
    return await repository.fetchDailyQuestion();
  }
}