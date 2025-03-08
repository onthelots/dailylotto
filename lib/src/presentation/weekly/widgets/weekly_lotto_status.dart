import 'package:dailylotto/src/presentation/main/bloc/weekly_lotto_bloc/weekly_lotto_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/constants.dart';
import '../../../data/models/lotto_local_model.dart';
import '../../main/bloc/lotto_local_bloc/lotto_local_state.dart';
import '../../main/bloc/weekly_lotto_bloc/weekly_lotto_state.dart';

class WeeklyLottoStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyLottoBloc, WeeklyLottoState>(
      builder: (context, localState) {
        if (localState is WeeklyLottoNumbersLoaded) {
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
        Row(
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
            SizedBox(
              width: 10,
            ),
            Tooltip(
              message: "매주 토요일 추첨이 완료되면\n다음 회차로 갱신됩니다.",
              textStyle: Theme.of(context).textTheme.labelSmall,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(10),
              triggerMode: TooltipTriggerMode.tap, // 👈 한 번만 눌러도 툴팁 표시
              showDuration: Duration(seconds: 2), // 2초 동안 표시
              child: Icon(
                Icons.info,
                size: 18,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),

        Container(
          padding: const EdgeInsets.symmetric(vertical: contentPaddingIntoBox, horizontal: contentPaddingIntoBox),

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
