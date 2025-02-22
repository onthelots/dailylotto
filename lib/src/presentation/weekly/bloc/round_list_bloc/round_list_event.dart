// 🟢 이벤트 정의
import 'package:equatable/equatable.dart';

abstract class RoundListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// ✅ 전체 데이터 로드
class LoadAllLottoNumbersEvent extends RoundListEvent {}
