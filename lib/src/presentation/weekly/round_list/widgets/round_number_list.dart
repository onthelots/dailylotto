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
        // 회차 섹션
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(
              vertical: contentPaddingIntoBox, horizontal: contentPaddingIntoBox),
          decoration: BoxDecoration(
            color: AppColors.darkTertiary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(3, 5),
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
                    const WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(
                      text:
                      '(${LottoUtils.formattedTimestamp(roundData.timeStamp)})',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: (roundData.winningNumbers ?? List.generate(6, (_) => -1))
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

        if (roundData.entries.isEmpty)
          _buildEmptyContainer(context)
        else
          _buildNumberList(context),
      ],
    );
  }

  // 회차에 생성한 번호가 없을 경우
  Widget _buildEmptyContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(
            vertical: contentPaddingIntoBox, horizontal: contentPaddingIntoBox),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(3, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "생성된 번호가 없습니다",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberList(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: roundData.entries.length,
      itemBuilder: (context, index) {
        final entry = roundData.entries[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.recommendation,
                arguments: RecommendationArgs(
                  round: roundData.round,
                  date: entry.date,
                  popUntil: false,
                ),
              );
            },
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(
                  vertical: contentPaddingIntoBox, horizontal: contentPaddingIntoBox),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    entry.date,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 11.0),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: entry.numbers
                          .map((num) => LottoUtils.lottoNumber(
                        number: num,
                        isCorrect:
                        roundData.winningNumbers?.contains(num) ?? false,
                      ))
                          .toList(),
                    ),
                  ),
                  Text(
                    entry.result ?? "예정",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
