import 'package:dailylotto/src/presentation/home/bloc/time_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimeCubit(),
      child: BlocBuilder<TimeCubit, TimePeriod>(
        builder: (context, state) {
          String title;
          String subtitle;
          String imagePath;
          Color backgroundColor;

          switch (state) {
            case TimePeriod.morning:
              title = "좋은 아침입니다️";
              subtitle = "오늘도 멋진 하루를 시작하세요!";
              imagePath = "assets/animations/morning_lottie.json";
              backgroundColor = Colors.yellow[100]!;
              break;
            case TimePeriod.lunch:
              title = "즐거운 점심시간! 🍱";
              subtitle = "맛있는 점심 드시고 힘내세요!";
              imagePath = "assets/animations/lunch_lottie.json";
              backgroundColor = Colors.orange[100]!;
              break;
            case TimePeriod.evening:
              title = "편안한 저녁 되세요! 🌙";
              subtitle = "오늘 하루도 수고 많으셨습니다!";
              imagePath = "assets/animations/evening_lottie.json";
              backgroundColor = Colors.blueGrey[100]!;
              break;
          }

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
            body: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                SizedBox(height: 30),

                // 중앙 이미지
                Lottie.asset(
                  imagePath,
                  repeat: false,
                  fit: BoxFit.fill,
                  frameRate: FrameRate.max,
                ),

                SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
