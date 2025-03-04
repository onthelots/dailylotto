import 'dart:math';
import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_bloc.dart';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../core/routes.dart';
import '../../../core/shared_preference.dart';
import '../../../core/utils.dart';
import '../../main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import '../../main/bloc/lotto_local_bloc/lotto_local_event.dart';
import '../../main/bloc/lotto_local_bloc/lotto_local_state.dart';
import '../../main/widgets/warning_check_dialog.dart';

class LottoNumberDisplay extends StatelessWidget {
  const LottoNumberDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return BlocBuilder<LottoLocalBloc, LottoLocalState>(
      builder: (context, state) {
        if (state is LottoNumbersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LottoNumbersLoaded) {

          // 당일, 로또번호를 생성했을 경우
          if (state.todayEntry != null && state.todayEntry!.numbers.isNotEmpty) {
            final List<int> todayNumbers = state.todayEntry!.numbers.toList()..sort();
            return _buildLottoDisplay(context: context, todayNumbers: todayNumbers, date: state.todayEntry!.date);
          } else {

            // 당일, 로또번호를 생성하지 않았을 경우
            final currentRound = state.lottoData.round;
            return _buildLottoGenerationButton(context: context, today: today, round: currentRound);
          }
        } else {
          return const Text("로또 데이터를 불러오는 중 오류 발생");
        }
      },
    );
  }

  // 로또 번호가 생성되었을 경우의 화면 구성
  Widget _buildLottoDisplay(
      {required BuildContext context,
      required List<int> todayNumbers,
      required String date}) {
    return BlocBuilder<TimeBloc, TimeState>(
      builder: (context, state) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: state.background,
          ),
          padding: const EdgeInsets.all(boxPadding),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2), // alpha 값만 설정
                  offset: Offset(0, 2), // 그림자 위치 (수평, 수직)
                  blurRadius: 3, // 흐림 정도 (작게 설정)
                  spreadRadius: 1, // 그림자의 확장 정도
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Daily pick',
                    style: Theme.of(context).textTheme.bodySmall),
                Wrap(
                  spacing: 8, // 번호 간격
                  children: todayNumbers
                      .map<Widget>((number) =>
                          LottoUtils.lottoBall(number: number, width: 30.0, height: 30.0)) // 위젯 리스트로 변환
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 로또 번호가 생성되지 않았을 경우 버튼 화면
  Widget _buildLottoGenerationButton(
      {required BuildContext context,
      required String today,
      required int round}) {
    return BlocBuilder<TimeBloc, TimeState>(
      builder: (context, state) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: state.background,
          ),
          padding: const EdgeInsets.all(boxPadding),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1), // alpha 값만 설정
                  offset: Offset(0, 2), // 그림자 위치 (수평, 수직)
                  blurRadius: 3, // 흐림 정도 (작게 설정)
                  spreadRadius: 1, // 그림자의 확장 정도
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 제목
                Text('오늘 생성된 번호가 없어요',
                    style: Theme.of(context).textTheme.labelMedium),

                // 생성하기
                TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_circle_right_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('AI 추천받기',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                  color: Theme.of(context).primaryColor)),
                    ],
                  ),
                  onPressed: () async {
                    // 2. 오늘 생성된 번호가 없을 경우
                    // 주의사항 확인여부 파악
                    final isWarningCheck = await SharedPreferencesHelper.getWaringCheckState();
                    isWarningCheck ?
                    Navigator.of(context).pushNamed(Routes.dailyQuestion, arguments: round)
                        :
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => WarningCheckDialog(
                        title: "번호 생성 전 주의사항",
                        subtitle:
                        "본 서비스는 엔터테인먼트 목적으로 번호 생성 기능을 제공하며, 생성된 번호는 당첨을 보장하지 않습니다.\n로또 구매 및 관련 행위는 전적으로 사용자 본인의 책임입니다.",
                        cancelText: "취소",
                        confirmText: "확인했어요!",
                        onConfirm: () async {
                          await SharedPreferencesHelper.setWaringCheckStateToTrue();
                          Navigator.of(context).pushNamed(Routes.dailyQuestion, arguments: round);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
