import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:staton/models/answer.dart';

//Класс созданный для управления локальной базой данныъ
class DBConnect {
  //Наша БД
  Database? database;

  //Открытие и инициализация БД
  Future<void> open() async {
    final String path = await getDatabasesPath();
    database = await openDatabase(
      join(path, 'staton.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE question(id INTEGER PRIMARY KEY, question TEXT, answer_number INTEGER)',
        );
      },
      version: 1,
    );
  }

  void close() async {
    if (database != null) {
      database!.close();
    }
  }

  //Вставка нового ответа в БД
  Future<void> insertQuestion(Answer answer) async {
    if (database == null) {
      return;
    } else {
      //Проверка наличия ответа на определённый вопрос
      try {
        final containCheck = await database!
            .query('question', where: 'id = ?', whereArgs: [answer.id]);
        if (containCheck.isEmpty) {
          await database!.insert('question', answer.toMap());
        }
      } catch (e) {
        print(e);
      }
    }
  }

  //Получение всех ответов
  Future<List<Answer>> getAllQuestions() async {
    if (database == null) {
      return [];
    } else {
      try {
        final List<Map<String, dynamic>> maps =
            await database!.query('question');
        return List.generate(
          maps.length,
          (index) => Answer(
            id: maps[index]['id'],
            question: maps[index]['question'],
            answer: maps[index]['answer_number'],
          ),
        );
      } catch (e) {
        print(e);
      }
      return [];
    }
  }
}
