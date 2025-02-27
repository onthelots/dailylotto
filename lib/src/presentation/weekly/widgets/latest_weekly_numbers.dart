import 'package:dailylotto/src/presentation/weekly/bloc/latest_round_bloc/latest_round_bloc.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/latest_round_bloc/latest_round_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes.dart';
import '../round_list/widgets/round_number_list.dart';

class LatestWeeklyNumberDisplay extends StatelessWidget {
  const LatestWeeklyNumberDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LatestRoundBloc, LatestRoundState>(
      builder: (context, state) {
        if (state is LatestRoundListLoaded) {
          final latestRoundList = state.latestRoundList;

          return Column(
            children: [
              Row(
                children: [
                  Text(
                    "내 생성 번호",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.allround);
                    },
                    child: Text(
                      "전체보기",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                ],
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: latestRoundList.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      RoundNumberList(roundData: latestRoundList[index]),
                    ],
                  );
                },
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
