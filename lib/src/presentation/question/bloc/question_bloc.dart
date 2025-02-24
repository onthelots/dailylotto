import 'package:dailylotto/src/domain/usecases/cst_question_usecase.dart';
import 'package:dailylotto/src/domain/usecases/lotto_local_usecase.dart';
import 'package:dailylotto/src/presentation/question/bloc/question_event.dart';
import 'package:dailylotto/src/presentation/question/bloc/question_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final GetThreeRandomQuestionsUseCase useCase;

  QuestionBloc({required this.useCase}) : super(QuestionLoadingState()) {
    on<LoadQuestionsEvent>((event, emit) async {
      emit(QuestionLoadingState());
      try {
        final questions = await useCase.execute();
        emit(QuestionLoadedState(questions));
      } catch (e) {
        emit(QuestionErrorState(e.toString()));
      }
    });
  }
}