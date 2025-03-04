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

    // 🔵 오늘 회차 데이터 불러오기
    on<LoadLottoNumbersEvent>((event, emit) async {
      emit(LottoNumbersLoading());
      try {
        print("--- 현재 회차 ${event.round} 업데이트 ---");
        print("LoadLottoNumbersEvent : 다가오는 회차는? ${event.round}");

        var lottoData = useCase.getLottoRound(event.round);

        if (lottoData == null) {
          print("LoadLottoNumbersEvent : ${event.round}회차 컨테이너에 저장된 데이터가 없습니다");
          await useCase.createNewRound(event.round);
          lottoData = await useCase.getLottoRound(event.round);
          print("LoadLottoNumbersEvent : ${event.round}회차 컨테이너를 생성합니다 (비어있는 Entry)");
        } else {
          print("LoadLottoNumbersEvent : ${event.round}회차 컨테이너가 이미 존재하네요!");
        }

        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

        // 🔹 이전 회차 데이터 가져오기
        final previousRound = event.round - 1;
        final previousData = useCase.getLottoRound(previousRound);

        // 🔹 오늘 날짜에 해당하는 Entry 찾기
        // 3가지 경우를 다루며 -> lottoData.entries (현재 컨테이너)를 사용함
        // 1) 현재 컨테이너에 오늘 날짜 데이터가 있음 -> 해당 데이터 반환
        // 2) 현재 컨테이너에 오늘 날짜 데이터가 없으나, 이전 엔트리에는 존재함 -> 이전 데이터에서 가져옴 (이건, 토요일에 컨테이너가 생성될 때, 당일 생성한 번호가 존재할 때 이전 회차 데이터를 가져와서 할당하는 것임)
        // 3) 현재 컨테이너와 이전 컨테이너 모두 없음 -> 기본값 생성
        LottoEntry todayEntry = (lottoData?.entries.firstWhere(
              (entry) => entry.date == today,
          orElse: () {
            // 이전 데이터에서 찾기
            if (previousData != null) {
              try {
                return previousData.entries.firstWhere(
                      (entry) => entry.date == today,
                );
              } catch (_) {
                print("LoadLottoNumbersEvent: 이전 회차인 ${previousRound} 컨테이너에 생성된 오늘 날짜의 번호가 없어요.");
              }
            }

            // TODO: - 이부분에서, 걍 회차가 없을 경우 orElse
            // 이전회차의 데이터를 중복적으로 리턴해서
            return LottoEntry(
              date: today,
              numbers: [],
              recommendReason: "추천 이유 없음",
              dailyTip: "\n오늘의 팁이 없나요?\nAI 추천을 통해\n번호를 생성해주세요!",
              isDefault: true,
            );
          },
        ))!;
        print("LoadLottoNumbersEvent: 오늘 번호를 생성하지 않았나요? ${todayEntry.isDefault}");
        emit(LottoNumbersLoaded(lottoData!, todayEntry)); // 현재 회차 Data
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

        // Loaded 상태가 아닐 경우에만 Loaded로 실행할 것
        emit(LottoNumbersLoaded(existingRound, newEntry));
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