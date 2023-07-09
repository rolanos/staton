import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:staton/models/answer_model.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<GetAllHistoryEvent>((event, emit) async {});
  }
}
