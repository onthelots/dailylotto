import 'package:dailylotto/src/presentation/question/bloc/question_bloc.dart';
import 'package:dailylotto/src/presentation/question/bloc/question_event.dart';
import 'package:dailylotto/src/presentation/question/bloc/question_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants.dart';
import 'core/di/locator.dart';

class ScatchScreen extends StatefulWidget {
  @override
  _ScatchScreenState createState() => _ScatchScreenState();
}

class _ScatchScreenState extends State<ScatchScreen> {
  int currentStep = 0;
  List<int?> answers = [null, null, null];

  void selectOption(int index) {
    setState(() {
      answers[currentStep] = index;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      if (currentStep < 2) {
        setState(() {
          currentStep++;
        });
      } else {
        showResultDialog();
      }
    });
  }

  void showResultDialog() {
    String resultText = """
    ${answers.map((e) => e != null ? "선택 ${e! + 1}" : "선택 안 함").join("\n")}
    """;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("결과"),
        content: Text(resultText, style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<QuestionBloc>()..add(LoadQuestionsEvent()),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
            scrolledUnderElevation: 0,
            title: Text(
              'AI 번호생성',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.color
                    ?.withValues(alpha: 0.6),
              ),
            ),
          ),
          body: BlocBuilder<QuestionBloc, QuestionState>(
            builder: (context, state) {
              if (state is QuestionLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is QuestionErrorState) {
                return Center(child: Text("오류 발생: ${state.message}"));
              } else if (state is QuestionLoadedState) {
                final questions = state.questions;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: boxPadding, vertical: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        /// Prograss Bar
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            value: (currentStep + 1) / 3,
                            backgroundColor: Colors.grey[400],
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                            strokeWidth: 3,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// Step
                        Text(
                          "Step ${currentStep + 1}",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor),
                        ),

                        const SizedBox(height: 10),

                        /// 질문
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: contentPaddingIntoBox,
                              horizontal: contentPaddingIntoBox),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: Column(
                              children: [

                                Text(
                                  questions[currentStep].question,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        /// 질문 리스트
                        Column(
                          children: List.generate(3, (index) {
                            bool isSelected = answers[currentStep] == index;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: GestureDetector(
                                onTap: () => selectOption(index),
                                child: Container(
                                  height: 60,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: contentPaddingIntoBox,
                                      horizontal: contentPaddingIntoBox),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Theme.of(context).highlightColor : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1), // 그림자 색상
                                        blurRadius: 10, // 흐림 정도 (값이 클수록 더 부드러운 그림자)
                                        spreadRadius: 2, // 그림자 확산 정도
                                        offset: Offset(3, 5), // 그림자의 위치 (x, y)
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      SizedBox(width: 5),

                                      Icon(
                                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                        color: isSelected ? Colors.white : Colors.black54,
                                      ),
                                      SizedBox(width: 10),

                                      Expanded(
                                        child: Text(
                                          questions[currentStep].options[index],
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isSelected ? Colors.white : Colors.black54, fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      );
  }
}