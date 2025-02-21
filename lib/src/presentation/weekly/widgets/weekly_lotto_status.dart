import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../data/models/lotto_local_model.dart';
import '../../main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import '../../main/bloc/lotto_local_bloc/lotto_local_state.dart';
import '../../main/bloc/lotto_remote_bloc/lotto_remote_bloc.dart';
import '../../main/bloc/lotto_remote_bloc/lotto_remote_state.dart';

class WeeklyLottoStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LottoRemoteBloc, LottoRemoteState>(
      builder: (context, remoteState) {
        if (remoteState is LottoLoaded) {
          final latestRound = remoteState.latestRound.round;

          return BlocBuilder<LottoLocalBloc, LottoLocalState>(
            builder: (context, localState) {
              if (localState is LottoNumbersLoaded) {
                return WeeklyLottoUI(
                  latestRound: latestRound,
                  entries: localState.lottoData.entries,
                );
              }
              return CircularProgressIndicator();
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class WeeklyLottoUI extends StatelessWidget {
  final int latestRound;
  final List<LottoEntry> entries;

  WeeklyLottoUI({required this.latestRound, required this.entries});

  @override
  Widget build(BuildContext context) {
    final List<String> weekDays = ['일', '월', '화', '수', '목', '금', '토'];
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday % 7)); // 이번 주 일요일
    final formattedDates = List.generate(
      7,
          (index) => DateFormat('yyyy-MM-dd').format(startOfWeek.add(Duration(days: index))),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "이번주 진행상황",
          style: Theme.of(context).textTheme.titleMedium,
        ),

        SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),

          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final date = formattedDates[index];
              final isGenerated = entries.any((entry) => entry.date == date);
              final isToday = date == DateFormat('yyyy-MM-dd').format(today);

              return Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).disabledColor,
                    backgroundImage: isGenerated ? AssetImage('assets/images/check.png') : null
                  ),

                  const SizedBox(height: 10),

                  Text(
                    weekDays[index],
                    style: isToday
                        ? Theme.of(context)
                            .textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                        : Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
