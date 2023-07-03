import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staton/models/answer.dart';
import 'package:staton/models/db_model.dart';

import '../../logic/bloc/question_bloc.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});
  final DBConnect db = DBConnect();

  @override
  Widget build(BuildContext context) {
    int lastTickedCard = -1;
    return Scaffold(
      body: FutureBuilder(
        future: db.open(),
        builder: (context, _) {
          return FutureBuilder(
            future: db.getAllQuestions(),
            builder: (context, state) {
              List<Answer>? data = state.data;
              if (data == null) {
                return Center(
                  child: Text("Нет данных"),
                );
              }

              List<bool> showInfo = [];
              for (int i = 0; i < data.length; i++) {
                showInfo.add(false);
              }

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<QuestionBloc>()
                            .add(GetQuestionInfoEvent(data[index].id));
                        showInfo[index] = !showInfo[index];
                        if (lastTickedCard != index) {
                          if (lastTickedCard != -1)
                            showInfo[lastTickedCard] = false;
                          lastTickedCard = index;
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 117, 46, 233),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: BlocBuilder<QuestionBloc, QuestionInitial>(
                          builder: (context, blocState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Text(data[index].id.toString() + '.'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(data[index].question,
                                            maxLines: null),
                                      ),
                                    ],
                                  ),
                                ),
                                (showInfo[index])
                                    ? SizedBox(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: blocState
                                                .question!.titels!.length,
                                            itemBuilder: (_, i) {
                                              return Container(
                                                padding: EdgeInsets.all(8),
                                                child: Column(
                                                  children: [
                                                    Text(blocState
                                                        .question!.titels![i]),
                                                    Text(
                                                        "${(blocState.question!.answersAmount![i] / blocState.question!.totalResponses!).toStringAsFixed(1)}%")
                                                  ],
                                                ),
                                              );
                                            }),
                                      )
                                    : SizedBox(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
