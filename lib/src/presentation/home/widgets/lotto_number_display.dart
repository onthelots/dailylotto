import 'dart:math';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_bloc.dart';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../core/utils.dart';
import '../../main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import '../../main/bloc/lotto_local_bloc/lotto_local_event.dart';
import '../../main/bloc/lotto_local_bloc/lotto_local_state.dart';

class LottoNumberDisplay extends StatelessWidget {
  const LottoNumberDisplay({Key? key}) : super(key: key);

  // 랜덤 로또번호 생성
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

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Container(
      child: Row(
        children: [
          // <----- 오른쪽 컨텐츠 (로또번호 생성 및 미 생성) ----->
          Expanded(
            child: BlocBuilder<LottoLocalBloc, LottoLocalState>(
              builder: (context, state) {
                if (state is LottoNumbersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LottoNumbersLoaded) {
                  if (state.todayEntry != null && state.todayEntry!.numbers.isNotEmpty) {

                    final List<int> todayNumbers = state.todayEntry!.numbers.toList()..sort();

                    return Container(
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 제목
                          Text(
                            "오늘의 숫자는?",
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Theme.of(context).primaryColor),
                          ),

                          const SizedBox(height: 5),

                          // 날짜
                          Text(
                            state.todayEntry!.date,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),

                          const SizedBox(height: 25),

                          // 로또 번호 (가로로 나열)
                          Wrap(
                            spacing: 8, // 번호 간격
                            children: todayNumbers
                                .map<Widget>((number) =>
                                    LottoUtils.lottoBall(number)) // 위젯 리스트로 변환
                                .toList(), // List<Widget>으로 변환
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "AI 번호 생성하기",
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              context.read<LottoLocalBloc>().add(
                                GenerateLottoNumbersEvent(
                                  round: state.lottoData.round,
                                  date: today,
                                  numbers: _generateUniqueLottoNumbers(),
                                  recommendReason: "운이 좋을 것 같아서!",
                                  dailyTip: "로또는 적당히 즐기세요!",
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 5,
                            ),
                            child: Text(
                              "시작",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  return const Text("로또 데이터를 불러오는 중 오류 발생");
                }
              },
            ),
          ),

          // <----- 오른쪽 Lottie 이미지 (항상 150x150 크기 유지) ----->
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 130,
              height: 150,
              child: BlocBuilder<TimeBloc, TimeState>(
                builder: (context, state) {
                  return Lottie.asset(state.imagePath, repeat: false);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
