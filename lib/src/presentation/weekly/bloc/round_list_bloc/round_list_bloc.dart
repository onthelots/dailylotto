import 'package:dailylotto/src/presentation/weekly/bloc/round_list_bloc/round_list_event.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/round_list_bloc/round_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/lotto_local_usecase.dart';

class RoundListBloc extends Bloc<RoundListEvent, RoundListState> {
  final LottoLocalUseCase useCase;

  RoundListBloc({required this.useCase}) : super(RoundListLoading()) {
    on<LoadAllLottoNumbersEvent>((event, emit) async {
      emit(RoundListLoading());
      try {
        final allData = useCase.getAllRounds();
        emit(RoundListLoaded(allData));
      } catch (e) {
        emit(RoundListError("모든 회차 데이터를 불러오는 중 오류 발생: ${e.toString()}"));
      }
    });
  }
}