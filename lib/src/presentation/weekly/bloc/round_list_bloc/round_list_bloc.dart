import 'package:dailylotto/src/presentation/weekly/bloc/round_list_bloc/round_list_event.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/round_list_bloc/round_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/lotto_local_model.dart';
import '../../../../domain/usecases/lotto_local_usecase.dart';

class RoundListBloc extends Bloc<RoundListEvent, RoundListState> {
  final LottoLocalUseCase useCase;
  List<LottoLocalModel> allRounds = []; // 원본 데이터 저장

  int? currentYear; // 현재 필터링된 연도
  int? currentMonth; // 현재 필터링된 월

  RoundListBloc({required this.useCase}) : super(RoundListLoading()) {

    // ✅ 전체 데이터 로드
    on<LoadAllLottoNumbersEvent>((event, emit) async {
      emit(RoundListLoading());
      try {
        final data = useCase.getAllRounds();

        // 🔹 회차 내림차순 정렬
        data.sort((a, b) => b.round.compareTo(a.round));

        // 🔹 당첨번호 및 생성번호 정렬
        for (var round in data) {
          round.winningNumbers?.sort(); // 당첨번호 오름차순 정렬
          for (var entry in round.entries) {
            entry.numbers.sort(); // 생성번호 오름차순 정렬
          }
        }

        allRounds = data; // 원본 데이터 저장

        emit(RoundListLoaded(allRounds));
      } catch (e) {
        emit(RoundListError("모든 회차 데이터를 불러오는 중 오류 발생: ${e.toString()}"));
      }
    });

    // ✅ 월별 필터 적용
    on<FilterByMonthEvent>((event, emit) async {
      emit(RoundListLoading());
      try {
        List<LottoLocalModel> filteredData;

        // ✅ "전체 보기" 선택 시, 원본 데이터 그대로 사용
        if (event.year == null && event.month == null) {
          filteredData = List.from(allRounds);
        } else {
          filteredData = allRounds.where((round) {
            final date = round.timeStamp;
            final matchYear = event.year == null || date.year == event.year;
            final matchMonth = event.month == null || date.month == event.month;
            return matchYear && matchMonth;
          }).toList();
        }

        // 🔹 회차 내림차순 정렬
        filteredData.sort((a, b) => b.round.compareTo(a.round));

        emit(RoundListLoaded(filteredData));
      } catch (e) {
        emit(RoundListError("월별 데이터 필터링 중 오류 발생: ${e.toString()}"));
      }
    });

    // ✅ 필터 해제 (전체 데이터 복원)
    on<ClearFilterEvent>((event, emit) async {
      emit(RoundListLoading());
      await Future.delayed(const Duration(milliseconds: 500)); // 살짝 지연 추가 가능
      emit(RoundListLoaded(allRounds));
    });
  }
}
