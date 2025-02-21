import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils.dart';
import '../../../data/models/lotto_remote_model.dart';

class LatestRoundDisplay extends StatelessWidget {
  const LatestRoundDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LottoRemoteBloc, LottoRemoteState>(
      builder: (context, remoteState) {
        if (remoteState is LottoLoaded) {
          final latestRound = remoteState.latestRound;
          return LatestRoundUI(latestRound: latestRound);
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class LatestRoundUI extends StatelessWidget {
  final LottoRemoteModel latestRound;

  LatestRoundUI({
    required this.latestRound,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "최근 회차 결과",
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${latestRound.round}회 ${latestRound.timestamp.toString()}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Wrap(
                    spacing: 8, // 번호 간격
                    children: latestRound.winningNumbers
                        .map<Widget>((number) =>
                        LottoUtils.lottoBall(number: number, width: 35.0, height: 35.0)) // 위젯 리스트로 변환
                        .toList(),
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text("+")),
                  LottoUtils.lottoBall(
                      number: latestRound.bonusNumber,
                      width: 35.0,
                      height: 35.0),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '1등 총 당첨금',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  Text(
                    '${LottoUtils.formatPrizeAmount(latestRound.firstWinAmount)} (${latestRound.firstPrizeWinners}명)',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}