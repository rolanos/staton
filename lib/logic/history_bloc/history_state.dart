part of 'history_bloc.dart';

@immutable
class HistoryState {
  final List<Answer>? list;

  HistoryState({this.list});
}

class HistoryInitial extends HistoryState {
  HistoryInitial({super.list});
}

class HistorySearching extends HistoryState {
  HistorySearching({super.list});
}
