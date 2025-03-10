import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/round_list_bloc/round_list_bloc.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/round_list_bloc/round_list_event.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/round_list_bloc/round_list_state.dart';
import 'package:dailylotto/src/presentation/weekly/round_list/widgets/round_filter_dialog.dart';
import 'package:dailylotto/src/presentation/weekly/round_list/widgets/round_number_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/locator.dart';

class AllRoundsScreen extends StatefulWidget {
  const AllRoundsScreen({super.key});

  @override
  State<AllRoundsScreen> createState() => _AllRoundsScreenState();
}

class _AllRoundsScreenState extends State<AllRoundsScreen> {
  int? selectedYear;
  int? selectedMonth;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          locator<RoundListBloc>()..add(LoadAllLottoNumbersEvent()),
      child: BlocBuilder<RoundListBloc, RoundListState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              scrolledUnderElevation: 0,
              title: Column(
                children: [
                  Text(
                    '회차별 생성번호',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    selectedYear != null && selectedMonth != null
                        ? '${selectedYear! % 100}년 ${selectedMonth!.toString()}월'
                        : '전체',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                // 필터 버튼 (선택한 년/월이 있으면 표시, 없으면 '전체')
                IconButton(
                  icon: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.sort),
                    ],
                  ),
                  onPressed: () async {
                    // ✅ Dialog를 열 때, Builder로 감싸 기존 context를 유지
                    showDialog(
                      context: context,
                      builder: (dialogContext) => FilterDialog(
                        selectedYear: selectedYear ?? DateTime.now().year,
                        selectedMonth: selectedMonth ?? DateTime.now().month,
                        onFilterSelected: (year, month) {
                          setState(() {
                            selectedYear = year;
                            selectedMonth = month;
                          });

                          // ✅ 여기서 dialogContext가 아니라, 원래 BlocProvider가 포함된 context 사용
                          context.read<RoundListBloc>().add(
                                FilterByMonthEvent(year: year, month: month),
                              );
                        },
                        onResetFilter: () {
                          context.read<RoundListBloc>().add(
                                ClearFilterEvent(),
                              );
                          setState(() {
                            selectedYear = null;
                            selectedMonth = null;
                          });
                        },
                      ),
                    );
                  },
                )
              ],
            ),
            body: BlocBuilder<RoundListBloc, RoundListState>(
              builder: (context, state) {
                if (state is RoundListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RoundListLoaded) {
                  final allLottoData = state.allLottoData;

                  if (allLottoData.isEmpty) {
                    return const Center(child: Text("저장된 로또 데이터가 없습니다."));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: contentPaddingIntoBox,
                        horizontal: contentPaddingIntoBox),
                    itemCount: allLottoData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: RoundNumberList(roundData: allLottoData[index]),
                      );
                    },
                  );
                } else if (state is RoundListError) {
                  return Center(child: Text("오류 발생: ${state.message}"));
                }

                return const Center(child: Text("데이터를 불러올 수 없습니다."));
              },
            ),
          );
        },
      ),
    );
  }
}
