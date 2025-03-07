// 🟢 BLoC 정의
import 'package:dailylotto/src/presentation/main/bloc/weekly_lotto_bloc/weekly_lotto_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/weekly_lotto_bloc/weekly_lotto_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/lotto_local_model.dart';
import '../../../../domain/usecases/lotto_local_usecase.dart';

class WeeklyLottoBloc extends Bloc<WeeklyLottoEvent, WeeklyLottoState> {
  final LottoLocalUseCase useCase;

  WeeklyLottoBloc({required this.useCase}) : super(WeeklyLottoNumbersLoading()) {
    // 🔵 오늘 회차 데이터 불러오기
    on<LoadWeeklyLottoEvent>((event, emit) async {
      emit(WeeklyLottoNumbersLoading());
      try {
        var lottoData = useCase.getLottoRound(event.round);

        // 새로 생성되는 회차 컨테이너가 없을 때 -> 생성
        if (lottoData == null) {
          await useCase.createNewRound(event.round);
          lottoData = await useCase.getLottoRound(event.round);
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
                print(
                    "LoadLottoNumbersEvent: 이전 회차인 $previousRound 컨테이너에 생성된 오늘 날짜의 번호가 없어요.");
              }
            }

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
        emit(WeeklyLottoNumbersLoaded(lottoData!, todayEntry)); // 현재 회차 Data
      } catch (e) {
        emit(WeeklyLottoNumbersError("로또 데이터를 불러오는 중 오류 발생: ${e.toString()}"));
      }
    });
  }
}