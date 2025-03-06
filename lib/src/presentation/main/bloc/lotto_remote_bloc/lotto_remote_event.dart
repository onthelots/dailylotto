import 'package:equatable/equatable.dart';

abstract class LottoRemoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLatestRound extends LottoRemoteEvent {}

// 로또번호 업로드 to Firestore
class SaveLottoEntry extends LottoRemoteEvent {
  final List<int> numbers;
  final int currrentRound;

  SaveLottoEntry({
    required this.numbers,
    required this.currrentRound,
  });

  @override
  List<Object?> get props => [numbers, currrentRound];
}