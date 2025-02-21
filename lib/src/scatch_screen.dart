import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScatchScreen extends StatefulWidget {
  @override
  _ScatchScreenState createState() => _ScatchScreenState();
}

class _ScatchScreenState extends State<ScatchScreen> {
  int currentStep = 0; // 현재 질문 단계 (0~2)
  List<int?> answers = [null, null, null]; // 3개의 답변 저장
  bool isLoading = false; // 로딩 상태

  void selectOption(int index) {
    setState(() {
      answers[currentStep] = index;
      if (currentStep < 2) {
        // 선택하면 바로 다음 단계로 넘어감
        currentStep++;
      } else {
        // 마지막 질문이므로 로딩을 시작하고 결과로 이동
        isLoading = true;
      }
    });

    // 3번째 질문에서 선택 후 2초간 로딩 인디케이터를 표시하고 결과를 보여줌
    if (currentStep == 3) {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false; // 로딩을 끝내고 결과 화면으로 이동
        });

        // 결과 다이얼로그 표시
        showResultDialog();
      });
    }
  }

  void showResultDialog() {
    String resultText = """
    질문 1: 선택 ${answers[0] != null ? answers[0]! + 1 : "없음"}
    질문 2: 선택 ${answers[1] != null ? answers[1]! + 1 : "없음"}
    질문 3: 선택 ${answers[2] != null ? answers[2]! + 1 : "없음"}
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
    List<String> questions = [
      "질문 1: 좋아하는 숫자는?",
      "질문 2: 가장 자주 쓰는 번호는?",
      "질문 3: 행운의 숫자는?",
    ];

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 질문 텍스트 애니메이션
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              child: Text(
                questions[currentStep], // 현재 질문 표시
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ).animate().fadeIn(duration: 600.ms).moveY(begin: 80, end: 0),
            ),

            // 선택지 버튼 (3개)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: answers[currentStep] == index
                            ? Colors.blueAccent
                            : Colors.grey[300],
                        foregroundColor: answers[currentStep] == index
                            ? Colors.white
                            : Colors.black,
                        minimumSize: Size(250, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                      onPressed: () => selectOption(index),
                      child: Text(
                        "선택 ${index + 1}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 1500.ms)
                        .then(delay: (index * 500).ms), // 버튼별 딜레이 조정
                  );
                }),
              ),
            ),

            // 로딩 인디케이터 표시 (마지막 선택 후)
            if (isLoading)
              Positioned(
                bottom: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
