class DailyQuestionModel {
  final String fortune;
  final List<OptionModel> options;
  final String question;
  final double randomValue;

  DailyQuestionModel({
    required this.fortune,
    required this.options,
    required this.question,
    required this.randomValue,
  });

  factory DailyQuestionModel.fromMap(Map<String, dynamic> map) {
    return DailyQuestionModel(
      fortune: map['fortune'] as String? ?? '', // 🔹 null 방지
      options: (map['options'] as List?)
          ?.map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [], // 🔹 null이면 빈 리스트
      question: map['question'] as String? ?? '',
      randomValue: (map['randomValue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OptionModel {
  final int optionId;
  final String text;
  final String reason;
  final List<int> numbers;

  OptionModel({
    required this.optionId,
    required this.text,
    required this.reason,
    required this.numbers,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      optionId: json['option_id'] as int? ?? 0, // 🔹 null 방지
      text: json['text'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      numbers: List<int>.from(json['numbers'] ?? []), // 🔹 null이면 빈 리스트
    );
  }
}
