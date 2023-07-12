import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:staton/models/answer_model.dart';
import 'package:staton/models/db_model.dart';
import 'package:staton/models/question_model.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryState()) {
    on<GetAllHistoryEvent>((event, emit) async {
      final DBConnect db = DBConnect();
      await db.open();
      final List<Answer> list = await db.getAllQuestions();
      emit(HistoryState(list: list));
    });

    on<SearchHistoryEvent>((event, emit) async {
      if (event.query == "") {
        add(GetAllHistoryEvent());
      }

      final DBConnect db = DBConnect();
      await db.open();
      final List<Answer> list = await db.getAllQuestions();

      List<Answer> newState = [];
      for (var element in list) {
        String helper = element.id.toString() + element.question.toLowerCase();
        if (helper.contains(event.query.toLowerCase())) {
          newState.add(element);
        }
      }
      emit(HistoryState(list: newState));
    });

    on<GetQuestionInfoEvent>((event, emit) async {
      final ref = FirebaseDatabase.instance.ref();

      try {
        final snapshot = await ref.child('question/${event.number}').get();
        if (snapshot.exists) {
          Map<String, dynamic> body = jsonDecode(jsonEncode(snapshot.value));
          final newState = Question.fromMap(body);
          emit(HistoryState(list: state.list, shownQuestion: newState));
        }
      } catch (e) {
        print(e);
      }
    });
  }
}
