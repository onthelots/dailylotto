import 'package:dailylotto/src/data/models/cst_question_model.dart';
import 'package:dailylotto/src/domain/repositories/cst_question_repository.dart';

class GetThreeRandomQuestionsUseCase {
  final CstQuestionRepository _repository;

  GetThreeRandomQuestionsUseCase(this._repository);

  Future<List<CSTQuestion>> execute() async {
    return await _repository.getThreeRandomQuestions();
  }
}