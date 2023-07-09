// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

///Модель вопроса
class Question {
  //Номер вопроса
  final int? number;
  //Всего ответов
  final int? totalResponses;
  //Описание вопроса
  final String? question;
  //Список с количеством ответов на вопросы соответственно
  final List<int>? answersAmount;
  //Варианты ответов
  final List<String>? titels;
  //Теги
  final List<String>? tags;

  Question(
      {this.question,
      this.number,
      this.totalResponses,
      this.titels,
      this.answersAmount,
      this.tags});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'total_responses': totalResponses,
      'question': question,
      'titels': titels,
      'answers_amount': answersAmount,
      'tags': tags,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
        number: map['number'] as int,
        totalResponses: map['total_responses'] as int,
        question: map['question'] as String,
        titels: List<String>.from((map['titels'])),
        answersAmount: List<int>.from((map['answers_amount'])),
        tags: List<String>.from((map['tags'])));
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source) as Map<String, dynamic>);

  Question copyWith({
    int? number,
    int? totalResponses,
    String? question,
    List<String>? titels,
    List<String>? tags,
    List<int>? answersAmount,
  }) {
    return Question(
      number: number ?? this.number,
      totalResponses: totalResponses ?? this.totalResponses,
      question: question ?? this.question,
      titels: titels ?? this.titels,
      tags: tags ?? this.tags,
      answersAmount: answersAmount ?? this.answersAmount,
    );
  }
}
