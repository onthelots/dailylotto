import 'package:equatable/equatable.dart';
import '../../../../data/models/lotto_local_model.dart';

abstract class RoundListState extends Equatable {
  @override
  List<Object?> get props => [];
}

// 로딩 상태
class RoundListLoading extends RoundListState {}

// 회차별 로딩
class RoundListLoaded extends RoundListState {
  final List<LottoLocalModel> allLottoData;

  RoundListLoaded(this.allLottoData);

  @override
  List<Object?> get props => [allLottoData];
}

// 에러 상태
class RoundListError extends RoundListState {
  final String message;

  RoundListError(this.message);

  @override
  List<Object?> get props => [message];
}