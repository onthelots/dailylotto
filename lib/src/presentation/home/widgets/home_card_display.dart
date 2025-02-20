import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCardDisplay extends StatelessWidget {
  const HomeCardDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LottoLocalBloc, LottoLocalState>(
      builder: (context, state) {
        final dailyTip = (state is LottoNumbersLoaded) ? state.todayEntry?.dailyTip : dailyTipPlaceholder;
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// 왼쪽 카드 (큰 카드)
                Expanded(
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack( // Stack을 사용하여 CircleAvatar를 고정
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Daily Tips",
                                  style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              // Flexible로 텍스트가 길어지면 자연스럽게 처리
                              Wrap(children: [
                                Text(
                                  dailyTip ?? dailyTipPlaceholder,
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
                          bottom: 10,
                          right: 10,
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

                const SizedBox(width: 15), // 좌우 간격

                /// 오른쪽 카드 그룹 (작은 카드 2개)
                Expanded(
                  child: Container(
                    height: 250,
                    child: Column(
                      children: [

                        /// 첫 번째 작은 카드
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
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
                                  bottom: 10,
                                  right: 10,
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

                        const SizedBox(height: 15), // 위아래 간격

                        /// 두 번째 작은 카드
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "최근 회차 결과",
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),

                                Positioned(
                                  bottom: 10,
                                  right: 10,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15), // 위아래 간격

            /// 앱 홈페이지 CARD
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(15),
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
                    Text('오늘 생성된 번호가 없습니다',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey)),

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
                                  .labelSmall
                                  ?.copyWith(
                                      color: Theme.of(context).primaryColor)),
                        ],
                      ),
                      onPressed: () {
                        //
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}