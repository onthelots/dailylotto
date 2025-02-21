import 'package:cloud_firestore/cloud_firestore.dart';

class LottoRemoteModel {
  final int round;
  final List<int> winningNumbers;
  final int bonusNumber;
  final DateTime timestamp;
  final int firstWinAmount;
  final int firstPrizeWinners;

  LottoRemoteModel({
    required this.round,
    required this.winningNumbers,
    required this.bonusNumber,
    required this.timestamp,
    required this.firstWinAmount,
    required this.firstPrizeWinners,
  });

  factory LottoRemoteModel.fromMap(Map<String, dynamic> map) {
    return LottoRemoteModel(
      round: map['round'] ?? 0,
      winningNumbers: List<int>.from(map['winningNumbers'] ?? []),
      bonusNumber: map['bonusNumber'] ?? 0,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      firstWinAmount: map['firstWinAmount'] ?? 0,
      firstPrizeWinners: map['firstPrizeWinners'] ?? 0,
    );
  }
}