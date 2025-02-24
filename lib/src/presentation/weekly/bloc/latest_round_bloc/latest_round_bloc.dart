import 'package:dailylotto/src/presentation/weekly/bloc/latest_round_bloc/latest_round_event.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/latest_round_bloc/latest_round_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/lotto_local_usecase.dart';

class LatestRoundBloc extends Bloc<LatestRoundEvent, LatestRoundState> {
  final LottoLocalUseCase useCase;
  LatestRoundBloc({required this.useCase}) : super(LatestRoundListLoading()) {

    // ✅ 전체 데이터 로드
    on<LoadLatestRoundEvent>((event, emit) async {
      emit(LatestRoundListLoading());
      try {
        final data = useCase.getAllRounds();
        final latestTwo = data.take(2).toList();

        // 🔹 회차 내림차순 정렬
        latestTwo.sort((a, b) => b.round.compareTo(a.round));

        // 🔹 당첨번호 및 생성번호 정렬
        for (var round in data) {
          round.winningNumbers?.sort(); // 당첨번호 오름차순 정렬
          for (var entry in round.entries) {
            entry.numbers.sort(); // 생성번호 오름차순 정렬
          }
        }

        emit(LatestRoundListLoaded(latestTwo));
      } catch (e) {
        emit(LatestRoundListError("최근 회차 데이터를 불러오는 중 오류 발생: ${e.toString()}"));
      }
    });
  }
}
