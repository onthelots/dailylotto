import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/data/models/lotto_local_model.dart';
import 'package:dailylotto/src/domain/usecases/lotto_local_usecase.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// 🟢 BLoC 정의
class LottoLocalBloc extends Bloc<LottoLocalEvent, LottoLocalState> {
  final LottoLocalUseCase useCase;

  LottoLocalBloc({required this.useCase}) : super(LottoNumbersLoading()) {

    // 🔵 선택한 일자 로또 데이터 불러오기
    on<LoadLottoNumbersEvent>((event, emit) async {
      emit(LottoNumbersLoading());
      try {
        var lottoData = useCase.getLottoRound(event.recommendationArgs.round);

        if (lottoData == null) return;

        LottoEntry selectedEntry = (lottoData.entries.firstWhere(
          (entry) => entry.date == event.recommendationArgs.date,
        ));
        emit(LottoNumbersLoaded(selectedEntry)); // 선택한 회차의 데이터
      } catch (e) {
        emit(LottoNumbersError("로또 데이터를 불러오는 중 오류 발생: ${e.toString()}"));
      }
    });

    // 🔵 로또 번호 생성 후 저장 + 업데이트
    on<GenerateLottoNumbersEvent>((event, emit) async {
      try {
        print("GenerateLottoNumbersEvent : 생성 시작");
        final existingRound = useCase.getLottoRound(event.round);
        print("GenerateLottoNumbersEvent : 현재 회차 정보 : ${existingRound?.round}");


        List<int> selectedNumbers = List.from(event.numbers);
        if (selectedNumbers.length < 6) {
          // 기존 숫자를 제외한 1~45의 남은 숫자 목록 생성
          List<int> availableNumbers = List.generate(45, (index) => index + 1)
              .where((int num) => !selectedNumbers.contains(num))
              .toList();

          // 남은 숫자를 무작위로 섞어서 부족한 개수만큼 추가
          availableNumbers.shuffle();
          selectedNumbers.addAll(availableNumbers.take(6 - selectedNumbers.length));
        }

        // 🔵 번호 정렬
        selectedNumbers.sort();

        final newEntry = LottoEntry(
          date: event.date,
          numbers: selectedNumbers,
          recommendReason: event.recommendReason,
          dailyTip: event.dailyTip,
        );

        existingRound?.entries.add(newEntry); // entry 추가
        print("GenerateLottoNumbersEvent : Entry가 추가된 exisingRound count : ${existingRound?.entries.length}");
        await useCase.saveLottoRound(existingRound!); // 저장 후 상태 갱신
        print("GenerateLottoNumbersEvent : 저장");
        emit(DailyLottoNumberCreated(newEntry));
      } catch (e) {
        emit(LottoNumbersError("로또 번호 생성 중 오류 발생: ${e.toString()}"));
      }
    });

    // 🔵 당첨번호 업데이트
    on<UpdateWinningNumbersEvent>((event, emit) async {
      try {
        await useCase.updateWinningNumbers(event.round, event.winningNumbers, event.bonusNumber);
      } catch (e) {
        emit(LottoNumbersError("당첨번호 업데이트 중 오류 발생: ${e.toString()}"));
      }
    });

    // 🟢 더미데이터 추가
    on<CreateDummyRoundData>((event, emit) async {
      try {
        await useCase.createDummyRoundLocalData(event.round); // 1159회차 데이터 추가
      } catch (e) {
        emit(LottoNumbersError("더미데이터 생성 실패: ${e.toString()}"));
      }
    });
  }
}