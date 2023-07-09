part of 'history_bloc.dart';

@immutable
abstract class HistoryEvent {}

//Получение всех ответов на вопросы
class GetAllHistoryEvent extends HistoryEvent {}

//Поиск определенных ответов на вопросы
class SearchHistoryEvent extends HistoryEvent {
  final String query;

  SearchHistoryEvent({required this.query});
}
