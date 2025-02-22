import 'package:dailylotto/src/presentation/weekly/bloc/round_list_bloc/round_list_bloc.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/round_list_bloc/round_list_event.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/round_list_bloc/round_list_state.dart';
import 'package:dailylotto/src/presentation/weekly/widgets/weekly_number_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/locator.dart';
import '../main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import '../main/bloc/lotto_local_bloc/lotto_local_state.dart';

class AllRoundsScreen extends StatelessWidget {
  const AllRoundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<RoundListBloc>()..add(LoadAllLottoNumbersEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text("로또 전체 회차 기록")),
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
                padding: const EdgeInsets.all(8.0),
                itemCount: allLottoData.length,
                itemBuilder: (context, index) {
                  return RoundNumberList(roundData: allLottoData[index]);
                },
              );
            } else if (state is RoundListError) {
              return Center(child: Text("오류 발생: ${state.message}"));
            }

            return const Center(child: Text("데이터를 불러올 수 없습니다."));
          },
        ),
      ),
    );
  }
}
