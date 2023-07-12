part of 'history_bloc.dart';

@immutable
class HistoryState {
  final List<Answer>? list;
  final Question? shownQuestion;
  HistoryState({this.list, this.shownQuestion});
}
