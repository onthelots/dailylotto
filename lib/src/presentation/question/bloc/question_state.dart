import 'package:dailylotto/src/data/models/cst_question_model.dart';

abstract class QuestionState {}

class QuestionLoadingState extends QuestionState {}

class QuestionLoadedState extends QuestionState {
  final List<CSTQuestion> questions;

  QuestionLoadedState(this.questions);
}

class QuestionErrorState extends QuestionState {
  final String message;

  QuestionErrorState(this.message);
}