import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:staton/models/answer_model.dart';
import 'package:staton/models/db_model.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<GetAllHistoryEvent>((event, emit) async {
      final DBConnect db = DBConnect();
      await db.open();
      final List<Answer> list = await db.getAllQuestions();
      emit(HistoryInitial(list: list));
    });

    on<SearchHistoryEvent>((event, emit) {
      List<String> searchingList = [];
      if (state.list != null) {
        for (var element in state.list!) {
          searchingList.add(element.id.toString() + element.question);
        }
      }
    });
  }
}
