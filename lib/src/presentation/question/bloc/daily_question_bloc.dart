import 'package:dailylotto/src/domain/usecases/daily_question_usecase.dart';
import 'package:dailylotto/src/presentation/question/bloc/daily_question_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'daily_question_event.dart';

class DailyQuestionBloc extends Bloc<DailyQuestionEvent, DailyQuestionState> {
  final DailyQuestionUseCase getDailyQuestionUseCase;

  DailyQuestionBloc({required this.getDailyQuestionUseCase})
      : super(DailyQuestionInitial()) {
    on<LoadDailyQuestionEvent>(_onLoadDailyQuestion);
  }

  Future<void> _onLoadDailyQuestion(
      LoadDailyQuestionEvent event, Emitter<DailyQuestionState> emit) async {
    emit(DailyQuestionLoading());
    try {
      final dailyQuiz = await getDailyQuestionUseCase();
      emit(DailyQuestionLoaded(dailyQuestion: dailyQuiz));
    } catch (e) {
      emit(DailyQuestionError(message: e.toString()));
    }
  }
}
