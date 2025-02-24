import 'package:dailylotto/src/data/models/cst_question_model.dart';
import 'package:dailylotto/src/domain/repositories/cst_question_repository.dart';

class GetThreeRandomQuestionsUseCase {
  final CstQuestionRepository repository;

  GetThreeRandomQuestionsUseCase({required this.repository});

  Future<List<CSTQuestion>> execute() async {
    return await repository.getThreeRandomQuestions();
  }
}