import 'package:dailylotto/src/data/models/lotto_stats_model.dart';
import 'package:equatable/equatable.dart';

abstract class LottoStatsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LottoStatsInitial extends LottoStatsState {}

class LottoStatsLoading extends LottoStatsState {}

class LottoStatsLoaded extends LottoStatsState {
  final LottoStatsModel roundData;
  LottoStatsLoaded({required this.roundData});

  @override
  List<Object?> get props => [roundData];
}

class LottoStatsError extends LottoStatsState {
  final String message;
  LottoStatsError({required this.message});

  @override
  List<Object?> get props => [message];
}