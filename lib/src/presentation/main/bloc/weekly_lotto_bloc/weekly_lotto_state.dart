import 'package:equatable/equatable.dart';
import '../../../../data/models/lotto_local_model.dart';

// 🟢 상태 정의
abstract class WeeklyLottoState extends Equatable {
  @override
  List<Object?> get props => [];
}

// ✅ 로딩 상태
class WeeklyLottoNumbersLoading extends WeeklyLottoState {}

// ✅ 이번 회차 컨테이너 및 오늘 번호
class WeeklyLottoNumbersLoaded extends WeeklyLottoState {
  final LottoLocalModel lottoData;
  final LottoEntry? todayEntry; // 오늘 생성된 로또 번호가 없으면 null, 있으면 해당 로또 번호 객체

  WeeklyLottoNumbersLoaded(this.lottoData, this.todayEntry);

  @override
  List<Object?> get props => [lottoData, todayEntry];
}

// ✅ 에러 상태
class WeeklyLottoNumbersError extends WeeklyLottoState {
  final String message;

  WeeklyLottoNumbersError(this.message);

  @override
  List<Object?> get props => [message];
}