import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/data/models/recommendation_args.dart';
import 'package:flutter/material.dart';
import '../../../../core/routes.dart';
import '../../../../core/utils.dart';
import '../../../../data/models/lotto_local_model.dart';

class RoundNumberList extends StatelessWidget {
  final LottoLocalModel roundData;

  const RoundNumberList({
    super.key,
    required this.roundData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// 회차 섹션
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(
              vertical: contentPaddingIntoBox,
              horizontal: contentPaddingIntoBox),
          decoration: BoxDecoration(
            color: AppColors.darkTertiary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1), // 그림자 색상
                blurRadius: 10, // 흐림 정도 (값이 클수록 더 부드러운 그림자)
                spreadRadius: 2, // 그림자 확산 정도
                offset: Offset(3, 5), // 그림자의 위치 (x, y)
              ),
            ],
          ),
          child: Row(
            children: [
              RichText(
                maxLines: 1,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${roundData.round}회",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.white),
                    ),
                    WidgetSpan(
                      child: SizedBox(width: 4), // 간격 추가
                    ),
                    TextSpan(
                        text:
                            '(${LottoUtils.formattedTimestamp(roundData.timeStamp)})',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              Spacer(),
              Row(
                children:
                    (roundData.winningNumbers ?? List.generate(6, (_) => -1))
                        .map((num) => LottoUtils.lottoSolidBall(
                              color: Theme.of(context).focusColor,
                              number: num,
                              width: 30.0,
                              height: 30.0,
                            ))
                        .toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        roundData.entries.isEmpty
            ? Container(
              height: 60,
              padding: const EdgeInsets.symmetric(
                  vertical: contentPaddingIntoBox,
                  horizontal: contentPaddingIntoBox),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1), // 그림자 색상
                    blurRadius: 10, // 흐림 정도 (값이 클수록 더 부드러운 그림자)
                    spreadRadius: 2, // 그림자 확산 정도
                    offset: Offset(3, 5), // 그림자의 위치 (x, y)
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "생성된 번호가 없습니다",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            )
            : Column(
                children: List.generate(roundData.entries.length, (index) {
                  final entry = roundData.entries[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.recommendation, arguments: RecommendationArgs(round: roundData.round, date: entry.date, popUntil: false));
                        },
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(
                              vertical: contentPaddingIntoBox,
                              horizontal: contentPaddingIntoBox),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                entry.date,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: 11.0),
                              ),

                              const SizedBox(width: 12.0), // 날짜와 로또 번호 사이 간격 추가

                              Row(
                                mainAxisSize: MainAxisSize.max, // ✅ Row를 가득 채우도록 설정
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: entry.numbers
                                    .map((int num) => LottoUtils.lottoNumber(
                                      number: num,
                                      isCorrect: roundData.winningNumbers
                                              ?.contains(num) ??
                                          false,
                                    ))
                                    .toList(),
                              ),

                              Spacer(),

                              Text(
                                entry.result ?? "예정",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  );
                }),
              )
      ],
    );
  }
}
