// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class NextQuestionEvent extends QuestionEvent {
  final List<ThemeQuestion>? params;
  NextQuestionEvent({
    this.params = null,
  });
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

class GetThemes extends QuestionEvent {}

class SetThemes extends QuestionEvent {
  final List<ThemeQuestion> list;

  SetThemes(this.list);
}
