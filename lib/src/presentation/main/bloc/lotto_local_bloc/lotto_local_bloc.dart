import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/data/models/lotto_local_model.dart';
import 'package:dailylotto/src/domain/usecases/lotto_local_usecase.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

import 'package:intl/intl.dart';

// 🟢 BLoC 정의
class LottoLocalBloc extends Bloc<LottoLocalEvent, LottoLocalState> {
  final LottoLocalUseCase useCase;

  LottoLocalBloc({required this.useCase}) : super(LottoNumbersLoading()) {

    // 🔵 특정 회차 데이터 불러오기
    on<LoadLottoNumbersEvent>((event, emit) async {
      emit(LottoNumbersLoading());
      try {
        print("LoadLottoNumbersEvent : try 구문 실행중");
        var lottoData = useCase.getLottoRound(event.round);
        if (lottoData == null) {
          print("LoadLottoNumbersEvent : lottoData가 null입니다.");
          await useCase.createNewRound(event.round);
          lottoData = await useCase.getLottoRound(event.round);
        } else {
          print("LoadLottoNumbersEvent : lottoData가 null이 아닙니다.");
        }

        // 오늘 생성된 로또 번호가 있는지 확인
        // >> 어제 생성했더라도, 오늘 날짜로 갱신하여 다시 앱을 실행시키면 > today에 생성된 Entry가 없으므로, 임시 데이터를 할당함
        final today = DateFormat('yyyy-MM-dd').format(
            DateTime.now());
        LottoEntry? todayEntry;
        todayEntry = lottoData?.entries.firstWhere(
              (entry) => entry.date == today,
          orElse: () => LottoEntry(
            date: today,
            numbers: [],  // 기본값
            recommendReason: reasonPlaceholder,
            dailyTip: dailyTipPlaceholder,
            isDefault: true,  // 기본값 처리
          ),
        );

        print("LoadLottoNumbersEvent : 오늘 저장된 Entry : ${todayEntry?.isDefault}");
        emit(LottoNumbersLoaded(lottoData!, todayEntry)); // 현재 회차 Data
      } catch (e) {
        emit(LottoNumbersError("로또 데이터를 불러오는 중 오류 발생: ${e.toString()}"));
      }
    });

    // 🔵 전체 회차 데이터 불러오기
    on<LoadAllLottoNumbersEvent>((event, emit) async {
      emit(LottoNumbersLoading());
      try {
        final allData = useCase.getAllRounds();
        emit(AllLottoNumbersLoaded(allData));
      } catch (e) {
        emit(LottoNumbersError("모든 회차 데이터를 불러오는 중 오류 발생: ${e.toString()}"));
      }
    });

    // 🔵 로또 번호 생성 후 저장 + 업데이트
    on<GenerateLottoNumbersEvent>((event, emit) async {
      try {
        print("GenerateLottoNumbersEvent : 생성 시작");
        final existingRound = useCase.getLottoRound(event.round);
        print("GenerateLottoNumbersEvent : 현재 회차 정보 : ${existingRound?.round}");
        final newEntry = LottoEntry(
          date: event.date,
          numbers: event.numbers,
          recommendReason: event.recommendReason,
          dailyTip: event.dailyTip,
        );

        existingRound?.entries.add(newEntry); // entry 추가

        print("GenerateLottoNumbersEvent : Entry가 추가된 exisingRound count : ${existingRound?.entries.length}");

        await useCase.saveLottoRound(existingRound!); // 저장 후 상태 갱신
        print("GenerateLottoNumbersEvent : 저장");


        emit(LottoNumbersLoaded(existingRound, newEntry)); // 상태 갱신
      } catch (e) {
        emit(LottoNumbersError("로또 번호 생성 중 오류 발생: ${e.toString()}"));
      }
    });

    // 🔵 당첨번호 업데이트
    on<UpdateWinningNumbersEvent>((event, emit) async {
      try {
        await useCase.updateWinningNumbers(event.round, event.winningNumbers);
        emit(UpdateWinningNumbers());
      } catch (e) {
        emit(LottoNumbersError("당첨번호 업데이트 중 오류 발생: ${e.toString()}"));
      }
    });
  }
}