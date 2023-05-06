import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/bloc/question_bloc.dart';

class AdminUI {
  ///Вызов формы заполнения вопроса
  static Future<void> adminTile(BuildContext context, double padding) {
    List<TextEditingController> answerAddList = [];
    TextEditingController questionController = TextEditingController();
    return showModalBottomSheet(
        context: context,
        backgroundColor: Color.fromARGB(255, 49, 51, 126),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 49, 51, 126),
                  borderRadius: BorderRadius.all(Radius.circular(padding))),
              width: double.maxFinite,
              child: Column(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          answerAddList.add(TextEditingController());
                        });
                      },
                      icon: const Icon(Icons.add)),
                  TextField(
                    decoration: const InputDecoration(
                        hintText: "Вопрос",
                        hintStyle: TextStyle(color: Colors.white)),
                    controller: questionController,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: answerAddList.length,
                    itemBuilder: (context, index) {
                      return TextField(
                        controller: answerAddList[index],
                        decoration: InputDecoration(
                            hintText: "Ответ ${index + 1}",
                            hintStyle: TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 117, 46, 233))),
                      onPressed: () {
                        context.read<QuestionBloc>().add(AddQuestionEvent(
                            questionController.text,
                            List.generate(answerAddList.length,
                                (index) => answerAddList[index].text)));
                        for (var i in answerAddList) {
                          i.clear();
                        }
                      },
                      child: const Text("Добавить вопрос")),
                ],
              ), //There is filling form
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
        content: TextField(
          controller: _controller,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
        actions: [
          TextButton(
              onPressed: () async {
                final ref = FirebaseDatabase.instance.ref();
                final answer = await ref.child('admin').get();
                if (answer.exists &&
                    answer.value.toString() == _controller.text) {
                  Navigator.of(context).pop();
                  adminTile(context, 16);
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
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
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
              "Данное приложение преднозначенно исключительно для ...",
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
