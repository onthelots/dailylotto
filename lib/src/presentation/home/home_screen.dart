import 'dart:math';
import 'package:dailylotto/src/presentation/home/bloc/time_cubit.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../data/models/lotto_local_model.dart';
import '../main/bloc/lotto_local_bloc/lotto_local_event.dart';

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
            body: BlocBuilder<LottoLocalBloc, LottoLocalState>(
                builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 13.0),
                child: Column(
                  children: [
                    // <----- 상단 타이틀 ----->
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        BlocBuilder<LottoLocalBloc, LottoLocalState>(
                          builder: (context, state) {
                            final today = DateFormat('yyyy-MM-dd').format(
                                DateTime.now());

                            if (state is LottoNumbersLoading) {
                              return CircularProgressIndicator();
                            } else if (state is LottoNumbersLoaded) {
                              if (state.todayEntry != null &&
                                  state.todayEntry!.numbers.isNotEmpty) {
                                // 오늘 생성된 로또 번호가 있을 때
                                return Column(
                                  children: [
                                    Text("오늘의 로또 번호: ${state.todayEntry!.numbers
                                        .join(", ")}"),
                                    Text("추천 이유: ${state.todayEntry!
                                        .recommendReason}"),
                                    Text("일일 팁: ${state.todayEntry!.dailyTip}"),
                                  ],
                                );
                              } else {
                                // 오늘 생성된 로또 번호가 없을 때
                                return Column(
                                  children: [
                                    Text("오늘 생성된 로또 번호가 없습니다."),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<LottoLocalBloc>().add(
                                          // 일단, 임시로 생성할 것
                                          // TODO: - 번호 생성 Game Screen으로 이동
                                          GenerateLottoNumbersEvent(
                                            round: state.lottoData.round,
                                            date: today,
                                            numbers: _generateUniqueLottoNumbers(),
                                            recommendReason: "운이 좋을 것 같아서!",
                                            dailyTip: "로또는 적당히 즐기세요!",
                                          ),
                                        );
                                      },
                                      child: Text("번호 생성하기"),
                                    )
                                  ],
                                );
                              }
                            } else {
                              return Text("오늘 생성된 로또 오류");
                            }
                          }
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          );
        },
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