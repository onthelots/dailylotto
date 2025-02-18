import 'package:equatable/equatable.dart';
import '../../../../data/models/lotto_local_model.dart';

// 🟢 상태 정의
abstract class LottoLocalState extends Equatable {
  @override
  List<Object?> get props => [];
}

// ✅ 로딩 상태
class LottoNumbersLoading extends LottoLocalState {}

// ✅ 특정 회차 로드 완료 상태
class LottoNumbersLoaded extends LottoLocalState {
  final LottoLocalModel lottoData;
  final LottoEntry? todayEntry; // 오늘 생성된 로또 번호가 없으면 null, 있으면 해당 로또 번호 객체

  LottoNumbersLoaded(this.lottoData, this.todayEntry);

  @override
  List<Object?> get props => [lottoData, todayEntry];
}

// ✅ 당첨번호 업데이트
class UpdateWinningNumbers extends LottoLocalState {}

// ✅ 전체 데이터 로드 완료 상태
class AllLottoNumbersLoaded extends LottoLocalState {
  final List<LottoLocalModel> allLottoData;

  AllLottoNumbersLoaded(this.allLottoData);

  @override
  List<Object?> get props => [allLottoData];
}

// ✅ 에러 상태
class LottoNumbersError extends LottoLocalState {
  final String message;

  LottoNumbersError(this.message);

  @override
  List<Object?> get props => [message];
}