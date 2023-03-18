import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import '../../models/question_model.dart';
import 'dart:math';
import 'dart:convert';
part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionInitial> {
  QuestionBloc() : super(QuestionInitial()) {
    on<NextQuestionEvent>((event, emit) async {
      final ref = FirebaseDatabase.instance.ref();
      //Количество вопросов
      final amount = await ref.child('data/number_of_questions').get();

      ///from 0 to amount-1
      final number = Random().nextInt((amount.value as int)) + 1;
      final snapshot = await ref.child('question/$number').get();
      if (snapshot.exists) {
        Map<String, dynamic> body = jsonDecode(jsonEncode(snapshot.value));
        final newState = Question.fromMap(body);
        emit(QuestionInitial(question: newState));
      }
    });
    on<QuestionAnswerEvent>((event, emit) async {
      final ref = FirebaseDatabase.instance.ref('question/${event.number}');
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
      await ref
          .child("data")
          .update({"number_of_questions": ((amount.value as int) + 1)});
      final Question newQuestion = Question(
          question: event.question,
          number: ((amount.value as int) + 1),
          totalResponses: 0,
          titels: event.titels,
          answersAmount: List<int>.generate(event.titels.length, (index) => 0));
      await ref
          .child('question/${(amount.value as int) + 1}')
          .set(newQuestion.toMap());
    });
  }
}
