import 'package:dailylotto/src/domain/usecases/lotto_remote_usecase.dart';
import 'package:dailylotto/src/presentation/lotto_stats/bloc/lotto_stats_event.dart';
import 'package:dailylotto/src/presentation/lotto_stats/bloc/lotto_stats_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LottoStatsBloc extends Bloc<LottoStatsEvent, LottoStatsState> {
  final LottoRemoteUseCase useCase;

  LottoStatsBloc({required this.useCase}) : super(LottoStatsInitial()) {

    on<FetchLottoStatsRound>((event, emit) async {
      emit(LottoStatsLoading());

      try {
        final roundData = await useCase.getRoundData(event.round);
        emit(LottoStatsLoaded(roundData: roundData));
      } catch (e) {
        emit(LottoStatsError(message: e.toString()));
      }
    });
  }
}