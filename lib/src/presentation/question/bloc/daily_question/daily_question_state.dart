import 'package:dailylotto/src/data/models/daily_question_model.dart';

abstract class DailyQuestionState {}

class DailyQuestionInitial extends DailyQuestionState {}

class DailyQuestionLoading extends DailyQuestionState {}

class DailyQuestionLoaded extends DailyQuestionState {
  final DailyQuestionModel? dailyQuestion;

  DailyQuestionLoaded({required this.dailyQuestion});
}

class DailyQuestionError extends DailyQuestionState {
  final String message;

  DailyQuestionError({required this.message});
}
