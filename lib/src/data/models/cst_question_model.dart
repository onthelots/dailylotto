class CSTQuestion {
  final int id;
  final String question;
  final List<String> options;

  CSTQuestion({required this.id, required this.question, required this.options});

  factory CSTQuestion.fromJson(Map<String, dynamic> json) {
    return CSTQuestion(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
    );
  }
}