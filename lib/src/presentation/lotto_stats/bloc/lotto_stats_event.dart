import 'package:equatable/equatable.dart';

abstract class LottoStatsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLottoStatsRound extends LottoStatsEvent {
  final int round;

  FetchLottoStatsRound({required this.round});

  @override
  List<Object?> get props => [round];
}