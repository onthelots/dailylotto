import 'package:dailylotto/src/presentation/weekly/widgets/latest_round_display.dart';
import 'package:dailylotto/src/presentation/weekly/widgets/latest_weekly_numbers.dart';
import 'package:dailylotto/src/presentation/weekly/widgets/weekly_lotto_status.dart';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/routes.dart';

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
        backgroundColor: Theme.of(context).primaryColor,
        scrolledUnderElevation: 0,
        leadingWidth: 200.0,
        leading: Align(
            alignment: Alignment.centerLeft, // 세로축 중앙, 가로축 왼쪽 정렬
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: appBarLeadingPadding),
              child: RichText(
                maxLines: 1,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "다음 추첨일까지",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium?.copyWith(color: Colors.white),
                    ),
                    WidgetSpan(
                      child: SizedBox(width: 4), // 간격 추가
                    ),
                    TextSpan(
                      text: getDDayText(),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.allround);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: boxPadding, vertical: boxPadding),
              child: Column(
                children: [
                  WeeklyLottoStatus(),
                  const SizedBox(
                    height: 40.0,
                  ),
                  LatestRoundDisplay(),
                ],
              ),
            ),
            const Divider(
              height: 40.0,
              thickness: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: boxPadding, vertical: boxPadding),
              child: Column(
                children: [
                  LatestWeeklyNumberDisplay(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}