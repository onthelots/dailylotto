import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/data/models/lotto_local_model.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_state.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_state.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/latest_round_bloc/latest_round_bloc.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/latest_round_bloc/latest_round_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routes.dart';
import '../../main/bloc/lotto_remote_bloc/lotto_remote_bloc.dart';

class HomeCardDisplay extends StatelessWidget {
  const HomeCardDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LottoLocalBloc, LottoLocalState>(
      builder: (context, state) {
        final LottoEntry? todayEntry;
        if ((state is LottoNumbersLoaded)) {
          todayEntry = state.todayEntry;
        } else {
          todayEntry = null;
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
                    onTap: () {
                      if (todayEntry?.isDefault == false) {
                        Navigator.of(context).pushNamed(Routes.recommendation);
                      } else {
                        // TODO: - 다이얼로그 띄우고 번호생성 뷰로 이동
                        print("오늘 생성된 번호가 없습니다");
                      }
                    },
                    child: Container(
                      height: 250,
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
                  child: Container(
                    height: 250,
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
                                  print("최근 회차결과");
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
                                              "최근 회차 결과",
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
                print("앱 Notion 페이지로 이동");
              },
              child: Container(
                height: 100,
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
                            "매일 새롭게 생성되는 AI 추천번호",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          RichText(
                            text: TextSpan(
                              text: "데일리 로또",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                  color: Theme.of(context)
                                      .primaryColor), // 원하는 색상 적용
                              children: [
                                TextSpan(
                                  text: "를 소개합니다",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium, // 기존 스타일 유지
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Spacer(),

                      Image.asset(
                        'assets/images/ai.png',
                        width: 80,
                        height: 80,
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