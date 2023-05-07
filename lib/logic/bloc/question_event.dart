part of 'question_bloc.dart';

@immutable
abstract class QuestionEvent {}

class QuestionAnswerEvent extends QuestionEvent {
  final int number;
  final int answerNumber;
  QuestionAnswerEvent(this.number, this.answerNumber);
}

class NextQuestionEvent extends QuestionEvent {}

class AddQuestionEvent extends QuestionEvent {
  final String question;
  final List<String> titels;
  final List<String> tags;
  AddQuestionEvent(this.question, this.titels, this.tags);
}
