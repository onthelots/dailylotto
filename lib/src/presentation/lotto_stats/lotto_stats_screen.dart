import 'package:dailylotto/src/domain/usecases/lotto_remote_usecase.dart';
import 'package:dailylotto/src/presentation/lotto_stats/bloc/lotto_stats_bloc.dart';
import 'package:dailylotto/src/presentation/lotto_stats/bloc/lotto_stats_event.dart';
import 'package:dailylotto/src/presentation/lotto_stats/bloc/lotto_stats_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/locator.dart';

class LottoStatsScreen extends StatefulWidget {
  final int latestRound;

  LottoStatsScreen({super.key, required this.latestRound});

  @override
  _LottoStatsScreenState createState() => _LottoStatsScreenState();
}

class _LottoStatsScreenState extends State<LottoStatsScreen> {
  int currentRound = 0; // 기본 회차 (최신 회차)
  List<String> availableRounds = []; // 사용할 수 있는 회차 리스트

  @override
  void initState() {
    super.initState();
    currentRound = widget.latestRound;
    _loadRounds(currentRound: widget.latestRound);
  }

  // 회차 데이터 가져오기
  Future<void> _loadRounds({required int currentRound}) async {
    // 최신 회차를 1162로 설정, 사용자가 선택할 수 있는 회차를 모두 나열
    List<String> rounds = [];
    for (int i = currentRound; i >= 1; i--) {
      rounds.add(i.toString());
    }

    setState(() {
      availableRounds = rounds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      LottoStatsBloc(useCase: locator<LottoRemoteUseCase>())
        ..add(FetchLottoStatsRound(round: currentRound)),
      child: BlocBuilder<LottoStatsBloc, LottoStatsState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
                scrolledUnderElevation: 0,
                centerTitle: true,
                title: Column(
                  children: [
                    Text(
                      '회차별 당첨통계',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '$currentRound회',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  // 회차 선택 버튼 (모달을 띄워서 선택)
                  IconButton(
                    icon: const Icon(Icons.sort),
                    onPressed: () {
                      // 모달 바텀 시트를 띄워서 회차 목록 선택
                      showModalBottomSheet(
                        showDragHandle: true,
                        enableDrag: true,
                        backgroundColor: Theme
                            .of(context)
                            .scaffoldBackgroundColor,
                        context: context,
                        builder: (BuildContext modalContext) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 회차별 통계보기 타이틀
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  '회차별 통계보기',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                              ),
                              Divider(
                                height: 20.0,
                                thickness: 5.0,
                                color: Theme
                                    .of(context)
                                    .cardColor,
                              ),
                              // 회차 목록
                              Expanded(
                                child: ListView(
                                  children: availableRounds.map((roundId) {
                                    bool isSelected = currentRound ==
                                        int.parse(roundId); // 현재 선택된 회차인지 확인
                                    return ListTile(
                                      title: Text(
                                        '$roundId회',
                                        style: isSelected ? Theme
                                            .of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                            fontWeight: FontWeight.bold) : Theme
                                            .of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                            fontWeight: FontWeight.w300),
                                      ),
                                      trailing: isSelected
                                          ? Icon(Icons.check, color: Theme
                                          .of(context)
                                          .primaryColor) // 선택된 회차에 체크 표시
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          currentRound = int.parse(roundId);
                                        });
                                        context.read<LottoStatsBloc>().add(
                                            FetchLottoStatsRound(
                                                round: currentRound));
                                        Navigator.pop(modalContext); // 모달 닫기
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              body: Container(
                child: Center(
                  // TODO: - Pie Chart 할당할 것
                  child: Text("차트"),
                ),
              )
          );
        },
      ),
    );
  }
}