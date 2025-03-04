import 'package:equatable/equatable.dart';

abstract class LatestRoundEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// ✅ 최근 2개 리스트 불러오기
class LoadLatestRoundEvent extends LatestRoundEvent {}