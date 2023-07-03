part of 'question_bloc.dart';

@immutable
abstract class QuestionEvent {}

class QuestionAnswerEvent extends QuestionEvent {
  final Question question;
  final int answerNumber;
  QuestionAnswerEvent(this.question, this.answerNumber);
}

class NextQuestionEvent extends QuestionEvent {}

class AddQuestionEvent extends QuestionEvent {
  final String question;
  final List<String> titels;
  final List<String> tags;
  AddQuestionEvent(this.question, this.titels, this.tags);
}
