import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:staton/models/answer_model.dart';
import 'package:staton/models/db_model.dart';
import 'package:staton/models/question_theme_model.dart';
import '../../models/question_model.dart';
import 'dart:math';
import 'dart:convert';
part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(QuestionInitial()) {
    //Получение следущего вопроса из Firebase
    on<NextQuestionEvent>((event, emit) async {
      if (event.params != null) {
        if (event.params!.isNotEmpty) {
          QuestionInitial.params = event.params;
        }
      } else {
        QuestionInitial.params = null;
      }

      //Параметры запроса вопроса
      final params = QuestionInitial.params;

      //Номер получаемого вопроса определяется рандомно
      int number = 1;

      //Firebase
      final ref = FirebaseDatabase.instance.ref();

      //Локальное хранение вопросов, на которые дан был ответ
      final prefs = await SharedPreferences.getInstance();

      //История отвеченных вопросов
      Set history = {};

      //получение последнего ответа
      int? check = prefs.getInt('last');

      //Количество вопросов
      final amount = await ref.child('data/number_of_questions').get();

      if (params == null) {
        //Подбираем рандомно вопрос, на который не было дано ответа.
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
      } else {
        try {
          List<int> numbers = [];
          for (var tag in params) {
            final resp = await ref.child('data/tags/${tag.theme}').get();
            final responseNumbers = (resp.value as List<Object?>);

            for (var value in responseNumbers) {
              numbers.add(value as int);
            }
            do {
              number = numbers[Random().nextInt(numbers.length)];
            } while (number == check);
          }
        } catch (e) {
          print(e);
        }
      }

      try {
        //Получаем новый вопрос
        final snapshot = await ref.child('question/$number').get();
        await prefs.setInt('last', number);

        ///from 0 to amount-1
        if (snapshot.exists) {
          Map<String, dynamic> body = jsonDecode(jsonEncode(snapshot.value));
          final newState = Question.fromMap(body);

          emit(QuestionInitial(question: newState));
        }
      } catch (e) {
        print(e);
      }
    });

    //Событие ответа на вопрос
    on<QuestionAnswerEvent>((event, emit) async {
      //Firebase path
      final ref =
          FirebaseDatabase.instance.ref('question/${event.question.number}');

      //Локально хранилище SharedPrefs
      final prefs = await SharedPreferences.getInstance();

      //Локальное хранилище для сохранения точной истории в SQLite
      final DBConnect db = DBConnect();

      //Вставка ответа в SQLite
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

      //Система асинхроннового обновления полей Firestore для исключения ошибок с счётчиком ответов
      try {
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
      } catch (e) {
        print(e);
      }
    });

    //Admin: Добавление нового вопроса
    on<AddQuestionEvent>((event, emit) async {
      //Firebase
      final ref = FirebaseDatabase.instance.ref();

      //Получение числа вопросов в Firebase
      final amount = await ref.child('data/number_of_questions').get();

      //Добавление вопроса в список тегов для большей скорости поиска
      try {
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
          }
        }
      } catch (e) {
        print(e);
      }

      //Обновление индекса количества вопросов
      try {
        await ref
            .child("data")
            .update({"number_of_questions": ((amount.value as int) + 1)});
      } catch (e) {
        print(e);
      }

      //Добавление модели нового вопроса в Firebase
      final Question newQuestion = Question(
          question: event.question,
          number: ((amount.value as int) + 1),
          totalResponses: 0,
          titels: event.titels,
          tags: event.tags,
          answersAmount: List<int>.generate(event.titels.length, (index) => 0));
      try {
        await ref
            .child('question/${(amount.value as int) + 1}')
            .set(newQuestion.toMap());
      } catch (e) {
        print(e);
      }
    });

    on<GetThemes>((event, emit) async {
      final ref = FirebaseDatabase.instance.ref();
      try {
        final snapshot = await ref.child('data/tags').get();
        if (snapshot.exists) {
          print(snapshot.value);
        }
        List<ThemeQuestion> listThemes = [];
        for (var key in (snapshot.value as Map<Object?, Object?>).keys) {
          listThemes.add(ThemeQuestion(theme: key as String));
        }
        emit(ChooseThemes(themes: listThemes));
      } catch (e) {
        print(e);
      }
    });

    on<SetThemes>((event, emit) => emit(ChooseThemes(themes: event.list)));
  }
}
