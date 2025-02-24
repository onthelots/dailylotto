import 'package:equatable/equatable.dart';
import '../../../../data/models/lotto_local_model.dart';

abstract class LatestRoundState extends Equatable {
  @override
  List<Object?> get props => [];
}

// 로딩 상태
class LatestRoundListLoading extends LatestRoundState {}

// 회차별 로딩
class LatestRoundListLoaded extends LatestRoundState {
  final List<LottoLocalModel> latestRoundList;

  LatestRoundListLoaded(this.latestRoundList);

  @override
  List<Object?> get props => [latestRoundList];
}

// 에러 상태
class LatestRoundListError extends LatestRoundState {
  final String message;

  LatestRoundListError(this.message);

  @override
  List<Object?> get props => [message];
}