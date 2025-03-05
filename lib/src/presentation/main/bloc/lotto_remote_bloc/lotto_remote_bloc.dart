import 'dart:math';

import 'package:dailylotto/src/data/models/lotto_remote_model.dart';
import 'package:dailylotto/src/domain/usecases/lotto_remote_usecase.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LottoRemoteBloc extends Bloc<LottoRemoteEvent, LottoRemoteState> {
  final LottoRemoteUseCase useCase;

  LottoRemoteBloc({required this.useCase}) : super(LottoInitial()) {
    
    // 최근 데이터 불러오기
    on<FetchLatestRound>((event, emit) async {
      emit(LottoLoading());

      try {
        await emit.forEach<LottoRemoteModel>(
          useCase.call(),
          onData: (latestRound) => LottoLoaded(latestRound: latestRound),
          onError: (error, stackTrace) => LottoError(message: error.toString()),
        );
      } catch (e) {
        emit(LottoError(message: e.toString()));
      }
    });

    // 데이터 저장 (firestore)
    on<SaveLottoEntry>((event, _) async {
      try {
        await useCase.saveLottoEntry(numbers: event.numbers, currentRound: event.currrentRound);
      } catch (e) {
        print("Save Lotto Entry Failed : $e");
      }
    });
    
  }
}