import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staton/logic/question_bloc/question_bloc.dart';

class AdminUI {
  ///Вызов формы заполнения вопроса
  static Future<void> adminTile(BuildContext context) {
    List<TextEditingController> answerAddList = [];
    List<TextEditingController> tagsList = [];
    TextEditingController questionController = TextEditingController();
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Color.fromARGB(255, 49, 51, 126),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 49, 51, 126),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              width: double.maxFinite,
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: [
                          //Варианты ответов на вопросы
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  answerAddList.add(TextEditingController());
                                });
                              },
                              icon: const Icon(Icons.question_mark)),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  tagsList.add(TextEditingController());
                                });
                              },
                              icon: const Icon(Icons.tag)),
                        ],
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Вопрос",
                            hintStyle: TextStyle(color: Colors.white)),
                        controller: questionController,
                      ),
                      //Список полей для добавления ответов на вопрос
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: answerAddList.length,
                        itemBuilder: (context, index) {
                          return TextField(
                            controller: answerAddList[index],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Ответ ${index + 1}",
                                hintStyle: TextStyle(color: Colors.white)),
                          );
                        },
                      ),
                      Divider(),
                      //Список полей для добавления тэгов
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: tagsList.length,
                        itemBuilder: (context, index) {
                          return TextField(
                            controller: tagsList[index],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Тег ${index + 1}",
                                hintStyle: TextStyle(color: Colors.white)),
                          );
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            questionController.text.trim();
                            for (var i = 0; i < answerAddList.length; i++) {
                              answerAddList[i].text.trim();
                            }
                            for (var i = 0; i < tagsList.length; i++) {
                              tagsList[i].text.trim();
                            }

                            context.read<QuestionBloc>().add(AddQuestionEvent(
                                questionController.text,
                                List.generate(answerAddList.length,
                                    (index) => answerAddList[index].text),
                                List.generate(tagsList.length,
                                    (index) => tagsList[index].text)));
                            //Очистка полей ввода
                            setState(() {
                              questionController.clear();
                              answerAddList = [];
                              tagsList = [];
                              answerAddList = [];
                            });
                          },
                          child: Text(
                            "Добавить вопрос",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  ///Окно ввода кодового слова для входа в панель администратора
  static Future<void> adminDilog(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 78, 87, 145),
              borderRadius: BorderRadius.all(Radius.circular(18))),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                final ref = FirebaseDatabase.instance.ref();
                final answer = await ref.child('admin').get();
                if (answer.exists &&
                    answer.value.toString() == _controller.text) {
                  Navigator.of(context).pop();
                  adminTile(context);
                }
              },
              child: Text(
                "Вход",
                style: Theme.of(context).textTheme.bodyMedium,
              ))
        ],
      ),
    );
  }

  ///Всплывающее окно с информацией о проекте
  static Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: Border.all(),
            title: GestureDetector(
              onDoubleTap: () {
                Navigator.of(context).pop();
                adminDilog(context);
              },
              child: Text(
                "Информация",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            content: Text(
              "Данное приложение создано исключительно в образовательных целях",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Назад",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          );
        });
  }
}
