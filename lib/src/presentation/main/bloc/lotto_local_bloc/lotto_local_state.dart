import 'package:equatable/equatable.dart';
import '../../../../data/models/lotto_local_model.dart';

// 🟢 상태 정의
abstract class LottoLocalState extends Equatable {
  @override
  List<Object?> get props => [];
}

// ✅ 로딩 상태
class LottoNumbersLoading extends LottoLocalState {}

// ✅ 회차 로드 완료 상태
class LottoNumbersLoaded extends LottoLocalState {
  final LottoEntry? selectEntry; // 오늘 생성된 로또 번호가 없으면 null, 있으면 해당 로또 번호 객체

  LottoNumbersLoaded(this.selectEntry);

  @override
  List<Object?> get props => [selectEntry];
}

// ✅ 생성 완료
class DailyLottoNumberCreated extends LottoLocalState {
  final LottoEntry? dailyEntry; // 오늘 생성된 로또 번호가 없으면 null, 있으면 해당 로또 번호 객체

  DailyLottoNumberCreated(this.dailyEntry);

  @override
  List<Object?> get props => [dailyEntry];
}

// ✅ 에러 상태
class LottoNumbersError extends LottoLocalState {
  final String message;

  LottoNumbersError(this.message);

  @override
  List<Object?> get props => [message];
}