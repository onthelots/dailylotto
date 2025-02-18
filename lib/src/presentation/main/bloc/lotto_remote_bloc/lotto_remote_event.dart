import 'package:equatable/equatable.dart';

abstract class LottoRemoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLatestRound extends LottoRemoteEvent {}