part of 'question_bloc.dart';

@immutable
abstract class QuestionEvent {}

class QuestionAnswerEvent extends QuestionEvent {
  //Модель вопроса
  final Question question;
  //Номер ответа на вопрос
  final int answerNumber;

  QuestionAnswerEvent(this.question, this.answerNumber);
}

class NextQuestionEvent extends QuestionEvent {}

class GetQuestionInfoEvent extends QuestionEvent {
  //Номер вопроса
  final int number;

  GetQuestionInfoEvent(this.number);
}

class AddQuestionEvent extends QuestionEvent {
  //Описание вопроса
  final String question;
  //Ответы
  final List<String> titels;
  //Теги
  final List<String> tags;

  AddQuestionEvent(this.question, this.titels, this.tags);
}
