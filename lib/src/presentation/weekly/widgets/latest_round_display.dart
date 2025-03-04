import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes.dart';
import '../../../core/utils.dart';
import '../../../data/models/lotto_remote_model.dart';
import '../../latest_result/lastest_result_screen.dart';

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

        const SizedBox(height: 15),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: contentPaddingIntoBox),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 회차
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${latestRound.round}회',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              letterSpacing: -0.2, fontWeight: FontWeight.w300,// 음수 값을 사용하면 간격이 줄어듦
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${LottoUtils.formattedTimestamp(latestRound.timestamp)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),

                      Spacer(),

                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.latestRoundResult, arguments: latestRound);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2), // 아래쪽으로 조금 내림
                              child: Text(
                                "내 번호 당첨확인",
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).focusColor),
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15.0,
                              color: Theme.of(context).focusColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

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
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "+",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                  LottoUtils.lottoBall(
                      number: latestRound.bonusNumber,
                      width: 35.0,
                      height: 35.0),
                ],
              ),
              const Divider(
                height: 50,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '1등 당첨금 (인당)',
                    style: Theme.of(context).textTheme.bodyMedium
                  ),

                  Spacer(),

                  RichText(
                    maxLines: 1,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${LottoUtils.formatPrizeAmount(latestRound.firstWinAmount)}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium?.copyWith(
                              letterSpacing: -0.5, fontWeight: FontWeight.bold),
                        ),
                        WidgetSpan(
                          child: SizedBox(width: 5), // 간격 추가
                        ),
                        TextSpan(
                          text: "(${latestRound.firstPrizeWinners}명)",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            letterSpacing: -0.3, // 음수 값을 사용하면 간격이 줄어듦
                          ),
                        ),
                      ],
                    ),
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