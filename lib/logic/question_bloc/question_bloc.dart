import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:staton/models/answer_model.dart';
import 'package:staton/models/db_model.dart';
import '../../models/question_model.dart';
import 'dart:math';
import 'dart:convert';
part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionInitial> {
  QuestionBloc() : super(QuestionInitial()) {
    on<NextQuestionEvent>((event, emit) async {
      int number;
      final ref = FirebaseDatabase.instance.ref();
      final prefs = await SharedPreferences.getInstance();
      Set history = {};
      int? check = prefs.getInt('last');
      //Количество вопросов
      final amount = await ref.child('data/number_of_questions').get();
      do {
        number = Random().nextInt((amount.value as int)) + 1;
        if (check == number) {
          history.add(number);
          continue;
        }
        bool isIncluded = prefs.containsKey('$number');
        if (!isIncluded) {
          break;
        } else {
          history.add(number);
        }
        if ((history.length == (amount.value as int))) {
          break;
        }
      } while (true);
      final snapshot = await ref.child('question/$number').get();
      await prefs.setInt('last', number);

      ///from 0 to amount-1
      if (snapshot.exists) {
        Map<String, dynamic> body = jsonDecode(jsonEncode(snapshot.value));
        final newState = Question.fromMap(body);
        emit(QuestionInitial(question: newState));
      }
    });
    on<QuestionAnswerEvent>((event, emit) async {
      final ref =
          FirebaseDatabase.instance.ref('question/${event.question.number}');
      final prefs = await SharedPreferences.getInstance();
      final DBConnect db = DBConnect();
      try {
        await db.open();
        final Answer answer = Answer(
            id: event.question.number ?? -1,
            question: event.question.question ?? "-",
            answer: event.answerNumber);
        db.insertQuestion(answer);
      } catch (e) {
        print(e);
      }
      await prefs.setBool('${event.question.number}', true);
      await ref.runTransaction(
        (Object? post) {
          // Ensure a post at the ref exists.
          if (post == null) {
            return Transaction.abort();
          }

          Map<String, dynamic> _post = Map<String, dynamic>.from(post as Map);
          _post['total_responses']++;
          _post['answers_amount'][event.answerNumber]++;
          // Return the new data.
          ref.update(_post);
          return Transaction.success(_post);
        },
      );
    });
    on<AddQuestionEvent>((event, emit) async {
      final ref = FirebaseDatabase.instance.ref();
      final amount = await ref.child('data/number_of_questions').get();
      final DataSnapshot tags;
      try {
        tags = await ref.child('data/tags').get();
        final map = tags.value;
        for (var tag in event.tags) {
          final DataSnapshot? response =
              await ref.child('data/tags/${tag}').get();
          if (response == null || !response.exists) {
            await ref
                .child('data/tags/${tag}')
                .set([(amount.value as int) + 1].asMap());
          } else {
            List<Object?> list = response.value as List<Object?>;
            list = list.toList();
            list.add((amount.value as int) + 1);
            await ref.child('data/tags/${tag}').set(list.asMap());
            // list.add((amount.value as int) + 1);
            // Map<String, Object?> newMap = {tag: list.map((e) => e)};
            // await ref.child('data/tags/${tag}').update(newMap);
          }
        }
      } catch (e) {
        print(e);
      }
      await ref
          .child("data")
          .update({"number_of_questions": ((amount.value as int) + 1)});
      final Question newQuestion = Question(
          question: event.question,
          number: ((amount.value as int) + 1),
          totalResponses: 0,
          titels: event.titels,
          tags: event.tags,
          answersAmount: List<int>.generate(event.titels.length, (index) => 0));
      await ref
          .child('question/${(amount.value as int) + 1}')
          .set(newQuestion.toMap());
    });
    on<GetQuestionInfoEvent>((event, emit) async {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('question/${event.number}').get();
      if (snapshot.exists) {
        Map<String, dynamic> body = jsonDecode(jsonEncode(snapshot.value));
        final newState = Question.fromMap(body);
        emit(QuestionInitial(question: newState));
      }
    });
  }
}