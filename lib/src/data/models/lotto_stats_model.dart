class LottoStatsModel {
  final int round;
  final int totalEntries;
  final Map<String, dynamic> winners; // 당첨자 목록

  LottoStatsModel({
    required this.round,
    required this.totalEntries,
    required this.winners,
  });

  // Firestore 데이터를 LottoStats로 변환
  factory LottoStatsModel.fromMap(Map<String, dynamic> data) {
    return LottoStatsModel(
      round: data['round'] ?? 0,
      totalEntries: data['totalEntries'] ?? 0,
      winners: data['winners'] ?? [],
    );
  }
}
