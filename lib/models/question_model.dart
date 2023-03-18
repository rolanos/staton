// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Question {
  final int? number;
  final int? totalResponses;
  final String? question;
  final List<String>? titels;
  final List<int>? answersAmount;

  Question(
      {this.question,
      this.number,
      this.totalResponses,
      this.titels,
      this.answersAmount});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'total_responses': totalResponses,
      'question': question,
      'titels': titels,
      'answers_amount': answersAmount,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
        number: map['number'] as int,
        totalResponses: map['total_responses'] as int,
        question: map['question'] as String,
        titels: List<String>.from((map['titels'])),
        answersAmount: List<int>.from((map['answers_amount'])));
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source) as Map<String, dynamic>);

  Question copyWith({
    int? number,
    int? totalResponses,
    String? question,
    List<String>? titels,
    List<int>? answersAmount,
  }) {
    return Question(
      number: number ?? this.number,
      totalResponses: totalResponses ?? this.totalResponses,
      question: question ?? this.question,
      titels: titels ?? this.titels,
      answersAmount: answersAmount ?? this.answersAmount,
    );
  }
}
