import 'dart:math';
import 'package:dailylotto/src/presentation/home/widgets/home_title_display.dart';
import 'package:dailylotto/src/presentation/home/widgets/lotto_number_display.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        leadingWidth: 200.0,
        leading: Align(
          alignment: Alignment.centerLeft, // 세로축 중앙, 가로축 왼쪽 정렬
          child: Padding(
              padding: const EdgeInsets.only(left: 13.0), // 좌측 여백 조정
              child: Row(
                children: [
                  Text('DailyLotto',
                      style: Theme.of(context).textTheme.labelLarge)
                ],
              )),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // TODO: - Trailing (Notification)
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // <----- 상단 타이틀 ----->
            // 상단 타이틀
            HomeTitleDisplay(),
            LottoNumberDisplay(),
          ],
        ),
      ),
    );
  }

  List<int> _generateUniqueLottoNumbers() {
    Random random = Random();
    Set<int> lottoNumbers = Set<int>();

    // 6개의 숫자를 생성할 때까지 반복
    while (lottoNumbers.length < 6) {
      int number = random.nextInt(45) + 1; // 1 ~ 45까지의 숫자
      lottoNumbers.add(number); // Set에 추가, 겹치면 자동으로 제외됨
    }

    return lottoNumbers.toList(); // Set을 List로 변환하여 반환
  }
}