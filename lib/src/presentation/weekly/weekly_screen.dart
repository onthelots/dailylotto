import 'package:dailylotto/src/presentation/weekly/widgets/latest_round_display.dart';
import 'package:dailylotto/src/presentation/weekly/widgets/weekly_lotto_status.dart';
import 'package:flutter/material.dart';

import '../../core/utils.dart';

class WeeklyScreen extends StatelessWidget {
  const WeeklyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    String getDDayText() {
      DateTime today = DateTime.now();
      int daysUntilSaturday = (6 - today.weekday) % 7; // 토요일(6)까지 남은 일수 계산

      if (today.weekday == 6) {
        return "D-DAY"; // 토요일이면 D-DAY로 표시
      }
      return "D-$daysUntilSaturday";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        leadingWidth: 200.0,
        leading: Align(
            alignment: Alignment.centerLeft, // 세로축 중앙, 가로축 왼쪽 정렬
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: RichText(
                maxLines: 1,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "다음 회차까지",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium,
                    ),
                    WidgetSpan(
                      child: SizedBox(width: 4), // 간격 추가
                    ),
                    TextSpan(
                      text: getDDayText(),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('준비중입니다'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Column(
                children: [
                  WeeklyLottoStatus(),

                  const SizedBox(
                    height: 30.0,
                  ),

                  LatestRoundDisplay(),

                  SizedBox(
                    height: 15.0,
                  ),
                  DrawNumbersList(
                    roundTitle: "1160회",
                    numbersList: [
                      [2, 3, 14, 28, 25, 41],
                      [2, 3, 14, 28, 25, 41],
                      [2, 3, 14, 28, 25, 41],
                    ],
                    statusList: ["예정", "예정", "예정"],
                  ),
                  DrawNumbersList(
                    roundTitle: "1160회",
                    numbersList: [
                      [2, 3, 14, 28, 25, 41],
                      [2, 3, 14, 28, 25, 41],
                      [2, 3, 14, 28, 25, 41],
                    ],
                    statusList: ["예정", "예정", "예정"],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 스크롤 전 보이는 헤더 UI
  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: WeeklyLottoStatus(),
        ),
      ],
    );
  }
}

// 🎯 재사용 가능한 회차별 번호 리스트 위젯
class DrawNumbersList extends StatelessWidget {
  final String roundTitle;
  final List<List<int>> numbersList;
  final List<String> statusList;

  const DrawNumbersList({
    super.key,
    required this.roundTitle,
    required this.numbersList,
    required this.statusList,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            roundTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: List.generate(numbersList.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: numbersList[index]
                            .map((num) => LottoUtils.lottoBall(number: num, width: 30.0, height: 30.0))
                            .toList(),
                      ),
                      Text(statusList[index]),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
