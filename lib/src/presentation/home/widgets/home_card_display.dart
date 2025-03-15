import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/core/shared_preference.dart';
import 'package:dailylotto/src/data/models/lotto_local_model.dart';
import 'package:dailylotto/src/data/models/recommendation_args.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_state.dart';
import 'package:dailylotto/src/presentation/main/bloc/weekly_lotto_bloc/weekly_lotto_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes.dart';
import '../../main/bloc/lotto_remote_bloc/lotto_remote_bloc.dart';
import '../../main/bloc/weekly_lotto_bloc/weekly_lotto_bloc.dart';
import '../../main/widgets/warning_check_dialog.dart';

class HomeCardDisplay extends StatelessWidget {
  const HomeCardDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyLottoBloc, WeeklyLottoState>(
      builder: (context, state) {
        final LottoEntry? todayEntry;
        final int? currentRound;

        if ((state is WeeklyLottoNumbersLoaded)) {
          todayEntry = state.todayEntry;
          currentRound = state.lottoData.round;
        } else {
          todayEntry = null;
          currentRound = null;  // Ensure it's assigned here
        }
        final dailyTip = todayEntry?.dailyTip ?? dailyTipPlaceholder;

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// 왼쪽 카드 (큰 카드)
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      // 1. 생성된 번호가 존재할 경우
                      if (todayEntry?.isDefault == false) {
                        Navigator.of(context).pushNamed(Routes.recommendation, arguments: RecommendationArgs(round: currentRound!, date: todayEntry!.date, popUntil: true));
                      } else {
                        // 2. 오늘 생성된 번호가 없을 경우
                        // 주의사항 확인여부 파악
                        final isWarningCheck = await SharedPreferencesHelper.getWaringCheckState();
                        isWarningCheck ?
                        Navigator.of(context).pushNamed(Routes.dailyQuestion, arguments: currentRound)
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
                              Navigator.of(context).pushNamed(Routes.dailyQuestion, arguments: currentRound);
                            },
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 260,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack( // Stack을 사용하여 CircleAvatar를 고정
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(contentPaddingIntoBox),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Daily Tips",
                                    style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Wrap(children: [
                                  Text(
                                    dailyTip,
                                    maxLines: 6,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ]),
                              ],
                            ),
                          ),

                          // CircleAvatar는 항상 하단 우측에 고정
                          Positioned(
                            bottom: 13,
                            right: 13,
                            child: Image.asset(
                              'assets/images/chat_bubble.png',
                              width: 60,
                              height: 60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15), // 좌우 간격

                /// 오른쪽 카드 그룹 (작은 카드 2개)
                Expanded(
                  child: SizedBox(
                    height: 260,
                    child: Column(
                      children: [

                        /// 첫 번째 작은 카드
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(Routes.allround);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(contentPaddingIntoBox),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          "생성번호 리스트",
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 13,
                                    right: 13,
                                    child: Image.asset(
                                      'assets/images/restaurant.png',
                                      width: 45,
                                      height: 45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15), // 위아래 간격

                        /// 두 번째 작은 카드
                        BlocBuilder<LottoRemoteBloc, LottoRemoteState>(
                          builder: (context, remoteState) {

                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (remoteState is LottoLoaded) {
                                    final latestRound = remoteState.latestRound;
                                    Navigator.of(context).pushNamed(Routes.latestRoundResult, arguments: latestRound);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            contentPaddingIntoBox),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              "내 최근 회차 결과",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 13,
                                        right: 13,
                                        child: Image.asset(
                                          'assets/images/award.png',
                                          width: 45,
                                          height: 45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15), // 위아래 간격

            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.webView, arguments: WebRoutes.appSite);
              },
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(contentPaddingIntoBox),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "매일 만나는 나만의 AI 추천번호",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          RichText(
                            text: TextSpan(
                              text: "데일리 로또",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                  color: Theme.of(context)
                                      .primaryColor), // 원하는 색상 적용
                              children: [
                                TextSpan(
                                  text: "를 소개합니다",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge, // 기존 스타일 유지
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Image.asset(
                        'assets/images/ai.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}