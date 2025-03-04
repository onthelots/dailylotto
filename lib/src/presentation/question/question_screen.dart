import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/core/utils.dart';
import 'package:dailylotto/src/data/models/daily_question_model.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_event.dart';
import 'package:dailylotto/src/presentation/question/bloc/daily_question_bloc.dart';
import 'package:dailylotto/src/presentation/question/bloc/daily_question_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../core/routes.dart';

class QuestionScreen extends StatefulWidget {
  final int currentRound;

  const QuestionScreen({super.key, required this.currentRound});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  String? _selectedOption; // 사용자가 선택한 답변
  DailyQuestionModel? _dailyQuestionContainer;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 뒤로 가기 동작을 비활성화
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          scrolledUnderElevation: 0,
          leading: SizedBox.shrink(), // 기본 back 버튼 제거
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                iconSize: 35.0,
                icon: Icon(
                  Icons.cancel,
                  color: Theme.of(context).hintColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      
        body: BlocBuilder<DailyQuestionBloc, DailyQuestionState>(
          builder: (context, state) {
            if (state is DailyQuestionLoading) {
              return Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
            } else if (state is DailyQuestionLoaded) {
              _dailyQuestionContainer = state.dailyQuestion;
      
              if (_dailyQuestionContainer == null) {
                return const Center(child: Text('질문 생성 실패.'));
              }
      
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: boxPadding, vertical: boxPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                
                      // 둥근 모서리 태그
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '당신의 선택은?',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                        ),
                      ),
      
                      SizedBox(
                        height: 5,
                      ),
                
                      // 질문 표시
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text(
                          _dailyQuestionContainer!.question,
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                
                      SizedBox(
                        height: 20,
                      ),
                
                      // 선택지 버튼
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _dailyQuestionContainer!.options.map((option) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: boxPadding, horizontal: boxPadding),
                            child: _buildOptionButton(option.text),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is DailyQuestionError) {
              return Center(child: Text('오류 발생: ${state.message}'));
            }
            return Center(child: Text('퀴즈 데이터를 불러오세요.'));
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          child: ElevatedButton(
            onPressed: _selectedOption == null
                ? null // 선택하지 않으면 비활성화
                : () => _handleRecommendation(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              backgroundColor: Theme
                  .of(context)
                  .highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              "선택하기",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // 선택지 버튼 생성
  Widget _buildOptionButton(String text) {
    bool isSelected = _selectedOption == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = (_selectedOption == text) ? null : text;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).cardColor, // 배경색
          border: Border.all( // 테두리 추가
            color: isSelected ? Theme.of(context).highlightColor : Colors.grey,
            width: 0.3,
          ),
        ),
        child: RadioListTile<String>(
          title: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isSelected ? Theme.of(context).highlightColor : null,
            ),
          ),
          value: text,
          groupValue: _selectedOption,
          onChanged: (String? value) {
            setState(() {
              _selectedOption = (_selectedOption == value) ? null : value;
            });
          },
          activeColor: Theme.of(context).highlightColor, // 선택 시 색상
          controlAffinity: ListTileControlAffinity.leading, // 왼쪽에 O 배치
        ),
      ),
    );
  }


  void _handleRecommendation() {
    if (_selectedOption == null || _dailyQuestionContainer == null) return;

    print("선택하기");

    final question = _dailyQuestionContainer!;
    final userSelectedOption = question.options.firstWhere(
          (option) => option.text == _selectedOption,
    );
    final navigator = Navigator.of(context);

    // 추천번호 생성
    context.read<LottoLocalBloc>().add(GenerateLottoNumbersEvent(
      round: widget.currentRound,
      date: LottoUtils.formattedTimestamp(DateTime.now()),
      numbers: userSelectedOption.numbers,
      recommendReason: userSelectedOption.reason,
      dailyTip: question.fortune,
    ));

    // 로딩 다이얼로그 표시
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 뒤로가기 못 하도록 방지
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Lottie.asset(
                    "assets/animations/generate_lottie.json",
                    repeat: false,
                    fit: BoxFit.fill,
                    frameRate: FrameRate.max,
                  ),
                ),
                const SizedBox(height: 15),
                Text("AI 추천번호 생성 중...", style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        );
      },
    );

    // 3초 후 로딩 다이얼로그 닫고 페이지 이동
    Future.delayed(const Duration(seconds: 3), () {
      if (navigator.mounted) {
        navigator.pop(); // 로딩 다이얼로그 닫기
        navigator.pushNamed(Routes.recommendation); // 페이지 이동
      }
    });
  }
}
