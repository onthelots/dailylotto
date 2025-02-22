import 'package:flutter/material.dart';
import '../../../core/utils.dart';
import '../../../data/models/lotto_local_model.dart';

class RoundNumberList extends StatelessWidget {
  final LottoLocalModel roundData;

  const RoundNumberList({
    super.key,
    required this.roundData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${roundData.round.toString()}회 (${roundData.timeStamp.toString()})",
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: roundData.entries.isEmpty
                ? Center(
              child: Text(
                "추천번호가 없습니다",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
                : Column(
              children: List.generate(roundData.entries.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: roundData.entries[index].numbers
                            .map((num) => LottoUtils.lottoNumber(
                          number: num,
                          width: 30.0,
                          height: 30.0,
                          isCorrect: roundData.winningNumbers?.contains(num) ?? false,
                          context: context,
                        ))
                            .toList(),
                      ),
                      Text(roundData.entries[index].result ?? "예정"),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
