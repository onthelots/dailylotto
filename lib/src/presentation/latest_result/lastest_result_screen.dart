import 'package:dailylotto/src/presentation/weekly/bloc/latest_round_bloc/latest_round_bloc.dart';
import 'package:dailylotto/src/presentation/weekly/round_list/widgets/round_number_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../data/models/lotto_local_model.dart';
import '../../data/models/lotto_remote_model.dart';
import '../weekly/bloc/latest_round_bloc/latest_round_state.dart';

class LastestResultScreen extends StatelessWidget {
  final LottoRemoteModel latestRound;
  const LastestResultScreen({super.key, required this.latestRound});

  @override
  Widget build(BuildContext context) {

    Color resultPrimaryColor = AppColors.lightSecondary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${latestRound.round}회 결과 ',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              '${LottoUtils.formattedTimestamp(latestRound.timestamp)} 추첨',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: BlocBuilder<LatestRoundBloc, LatestRoundState>(
        builder: (context, state) {
          if (state is LatestRoundListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LatestRoundListLoaded) {
            final roundData = state.latestRoundList.firstWhere(
              (r) => r.round == latestRound.round,
              orElse: () => LottoLocalModel(
                  round: latestRound.round,
                  entries: [],
                  timeStamp: DateTime.now()),
            );

            if (roundData.entries.isEmpty) {
              return Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset('assets/images/empty.png', fit: BoxFit.contain,),
                  ),
                  Text(
                    '최근 추첨회차에 생성한 번호가 없어요',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '다음 회차를 목표로 매일 번호를 생성하세요!',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ));
            }

            final hasWinningEntry = roundData.entries.any((entry) =>
            entry.result == "1등" ||
                entry.result == "2등" ||
                entry.result == "3등" ||
                entry.result == "4등" ||
                entry.result == "5등");

            final String resultTitleText = hasWinningEntry ? '당첨입니다!' : '낙첨이네요';
            final String resultSubtitleText = hasWinningEntry ? '상세 결과를 확인해보세요' : '아쉽지만 다음 회차에 도전해보세요';
            resultPrimaryColor = hasWinningEntry ? Theme.of(context).focusColor : Theme.of(context).highlightColor;
            final Image resultAssetImage = hasWinningEntry ? Image.asset('assets/images/win.png') : Image.asset('assets/images/lose.png');

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    width: 200,
                    height: 200,
                    child: resultAssetImage,
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Column(
                    children: [
                      Text(
                        resultTitleText,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.w900, color: resultPrimaryColor, fontSize: 38),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        resultSubtitleText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is LatestRoundListError) {
            return Center(child: Text('오류 발생: ${state.message}'));
          }
          return Center(
              child: Text('최근 회차에 생성된 번호가 없습니다',
                  style: Theme.of(context).textTheme.titleMedium));
        },
      ),
      bottomNavigationBar: BlocBuilder<LatestRoundBloc, LatestRoundState>(
        builder: (context, state) {
          if (state is LatestRoundListLoaded) {
            final roundData = (state.latestRoundList
              ..sort((a, b) => b.timeStamp.compareTo(a.timeStamp)))
                .firstWhere(
                  (r) => r.round == latestRound.round,
              orElse: () => LottoLocalModel(round: latestRound.round, entries: [], timeStamp: DateTime.now()),
            );

            final sortedEntries = List.of(roundData.entries)
              ..sort((a, b) => b.date.compareTo(a.date));

            if (roundData.entries.isEmpty) {
              return const SizedBox.shrink(); // 🔹 데이터가 없으면 bottomNavigationBar 숨김
            }

            return Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 50.0, horizontal: 35.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        showDragHandle: true,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        isScrollControlled: true,
                        builder: (context) {
                          return DraggableScrollableSheet(
                            expand: false,
                            builder: (context, scrollController) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                        "${state.latestRoundList.first.round}회 생성번호",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge?.copyWith(color: resultPrimaryColor, fontWeight: FontWeight.w900)),
                                  ),

                                  Divider(
                                    height: 20.0,
                                    thickness: 5.0,
                                    color: Theme.of(context).cardColor,
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Expanded(
                                    child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: sortedEntries.length,
                                      itemBuilder: (context, index) {
                                        final entry = sortedEntries[index];
                                        final isWinningEntry = ["1등", "2등", "3등", "4등", "5등"].contains(entry.result);

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).cardColor,
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  border: Border.all(
                                                    color: isWinningEntry
                                                        ? Theme.of(context).focusColor
                                                        : Theme.of(context).disabledColor,
                                                    width: isWinningEntry
                                                        ? 2.0
                                                        : 0.5,
                                                  ),
                                                ),
                                                child: ListTile(
                                                  title: Text(
                                                    '${entry.date}',
                                                    style: Theme.of(context).textTheme.bodySmall,
                                                  ),
                                                  subtitle: Text(
                                                    '${entry.numbers.join(', ')}',
                                                    style: Theme.of(context).textTheme.titleMedium,
                                                  ),
                                                  trailing: Text(
                                                    entry.result ?? "예정",
                                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                      fontWeight: isWinningEntry ? FontWeight.w900 : FontWeight.w300,
                                                      color: isWinningEntry ? resultPrimaryColor : null,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.0), // 🔹 간격 추가
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: resultPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child:
                    Text("결과 상세보기", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                  ),

                  const SizedBox(height: 15), // 🔹 버튼 간 간격 조정

                  ElevatedButton(
                    onPressed: () {
                      //
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: resultPrimaryColor, width: 0.2),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child:
                    Text("동행복권 홈페이지로", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: resultPrimaryColor)),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink(); // 🔹 기본적으로 숨김
        },
      ),
    );
  }
}