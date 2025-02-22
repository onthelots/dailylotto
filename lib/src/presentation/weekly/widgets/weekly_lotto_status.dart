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
    return BlocBuilder<LottoLocalBloc, LottoLocalState>(
      builder: (context, localState) {
        if (localState is LottoNumbersLoaded) {
          return WeeklyLottoUI(
            latestRound: localState.lottoData.round,
            entries: localState.lottoData.entries,
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
        RichText(
          maxLines: 1,
          text: TextSpan(
            children: [
              TextSpan(
                text: "이번주 진행상황",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium,
              ),
              WidgetSpan(
                child: SizedBox(width: 5), // 간격 추가
              ),
              TextSpan(
                text: "(${latestRound}회차)",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  letterSpacing: -0.3, // 음수 값을 사용하면 간격이 줄어듦
                ),
              ),
            ],
          ),
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

                  const SizedBox(height: 3),

                  if (isToday)
                    Container(
                      width: 13, // 텍스트 너비만큼 동적으로 설정하려면 LayoutBuilder를 사용할 수도 있음
                      height: 2.5, // 높이 조절
                      color: Theme.of(context).primaryColor, // 오늘 날짜 강조 색상
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
