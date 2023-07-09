part of 'history_bloc.dart';

@immutable
abstract class HistoryState {}

class HistoryInitial extends HistoryState {
  final List<Answer>? list;

  HistoryInitial({this.list = const []});
}

class HistorySearching extends HistoryState {}
