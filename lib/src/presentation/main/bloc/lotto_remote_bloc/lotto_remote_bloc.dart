import 'package:dailylotto/src/data/models/lotto_remote_model.dart';
import 'package:dailylotto/src/domain/usecases/lotto_remote_usecase.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LottoRemoteBloc extends Bloc<LottoRemoteEvent, LottoRemoteState> {
  final LottoRemoteUseCase useCase;

  LottoRemoteBloc({required this.useCase}) : super(LottoInitial()) {
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
  }
}