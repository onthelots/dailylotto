import 'package:dailylotto/src/data/models/lotto_remote_model.dart';
import 'package:equatable/equatable.dart';

abstract class LottoRemoteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LottoInitial extends LottoRemoteState {}

class LottoLoading extends LottoRemoteState {}

class LottoLoaded extends LottoRemoteState {
  final LottoRemoteModel latestRound;
  LottoLoaded({required this.latestRound});

  @override
  List<Object?> get props => [latestRound];
}

class LottoError extends LottoRemoteState {
  final String message;
  LottoError({required this.message});

  @override
  List<Object?> get props => [message];
}