// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'question_bloc.dart';

@immutable
abstract class QuestionState {}

class QuestionInitial extends QuestionState {
  final Question? question;

  QuestionInitial({this.question});

  QuestionInitial copyWith({
    Question? question,
  }) {
    return QuestionInitial(
      question: question ?? this.question,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question': question?.toMap(),
    };
  }

  factory QuestionInitial.fromMap(Map<String, dynamic> map) {
    return QuestionInitial(
      question: map['question'] != null
          ? Question.fromMap(map['question'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionInitial.fromJson(String source) =>
      QuestionInitial.fromMap(json.decode(source) as Map<String, dynamic>);
}
