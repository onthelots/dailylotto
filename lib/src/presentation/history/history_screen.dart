import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("로또 최신 회차")),
        body: BlocBuilder<LottoRemoteBloc, LottoRemoteState>(
          builder: (context, state) {
            if (state is LottoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is LottoLoaded) {
              final latest = state.latestRound;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("회차: ${latest.round}", style: TextStyle(fontSize: 24)),
                    Text("당첨 번호: ${latest.winningNumbers.join(", ")}",
                        style: TextStyle(fontSize: 18)),
                    Text("보너스 번호: ${latest.bonusNumber}",
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
              );
            } else if (state is LottoError) {
              return Center(child: Text("에러: ${state.message}"));
            }
            return Center(child: Text("데이터 없음"));
          },
        ),
    );
  }
}
