import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/bloc/question_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TextEditingController> answerAddList = [];
  TextEditingController questionController = TextEditingController();
  final padding = 18.0;
  bool showStat = false;
  bool isLoaded = false;
  int numberTicked = -1;
  int currentTickedIndex = -1;
  List<bool> isTicked = [];
  @override
  void initState() {
    super.initState();
    context.read<QuestionBloc>().add(NextQuestionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: const Color.fromARGB(255, 46, 27, 77),
              builder: (context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) =>
                      Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 46, 27, 77),
                        borderRadius:
                            BorderRadius.all(Radius.circular(padding))),
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
                          controller: questionController,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: answerAddList.length,
                          itemBuilder: (context, index) {
                            return TextField(
                              controller: answerAddList[index],
                            );
                          },
                        ),
                        TextButton(
                            onPressed: () {
                              context.read<QuestionBloc>().add(AddQuestionEvent(
                                  questionController.text,
                                  List.generate(answerAddList.length,
                                      (index) => answerAddList[index].text)));
                              for (var i in answerAddList) {
                                i.clear();
                              }
                            },
                            child: const Text("Add")),
                      ],
                    ), //There is filling form
                  ),
                );
              });
        },
      ),
      backgroundColor: Color.fromARGB(255, 0, 1, 66),
      body: BlocBuilder<QuestionBloc, QuestionInitial>(
        builder: (context, state) {
          if (state.question != null) {
            if (isLoaded == false) {
              for (var i = 0; i < state.question!.titels!.length; i++) {
                isTicked.add(false);
              }
              isLoaded = true;
            }
            return Center(
              child: Container(
                margin: EdgeInsets.all(padding),
                padding: EdgeInsets.all(padding),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(padding * 1.33)),
                    color: const Color.fromARGB(255, 46, 27, 77)),
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${state.question!.number}. ${state.question!.question}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Divider(
                      height: padding,
                      thickness: 0.5,
                      color: Theme.of(context).textTheme.bodyMedium!.color ??
                          const Color.fromARGB(255, 228, 255, 248),
                    ),
                    ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: state.question!.titels!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (currentTickedIndex != -1 &&
                                    index != currentTickedIndex) {
                                  isTicked[currentTickedIndex] = false;
                                }
                                setState(() {
                                  isTicked[index] = !isTicked[index];
                                });
                                currentTickedIndex = index;
                                numberTicked = state.question!.number!;
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        isTicked[index]
                                            ? const Color.fromARGB(
                                                255, 117, 46, 233)
                                            : const Color.fromARGB(
                                                255, 46, 27, 77)),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${state.question!.titels![index]}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            (showStat)
                                ? LinearPercentIndicator(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    barRadius: Radius.circular(padding),
                                    animation: true,
                                    lineHeight: 8,
                                    backgroundColor:
                                        const Color.fromARGB(255, 46, 27, 77),
                                    animationDuration: 1500,
                                    percent: (state.question!.totalResponses! ==
                                            0)
                                        ? (state.question!
                                                .answersAmount![index] /
                                            (state.question!.totalResponses! +
                                                1))
                                        : (state.question!
                                                .answersAmount![index] /
                                            (state.question!.totalResponses!)),
                                    progressColor:
                                        const Color.fromARGB(255, 117, 46, 233),
                                    trailing: Text(
                                      "${(state.question!.totalResponses! == 0) ? (100 * (state.question!.answersAmount![index] / (state.question!.totalResponses! + 1))).toStringAsFixed(1) : (100 * (state.question!.answersAmount![index] / (state.question!.totalResponses!))).toStringAsFixed(1)}%",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  )
                                : const SizedBox(
                                    height: 4,
                                    width: double.maxFinite,
                                  ),
                          ],
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: (showStat)
                          ? IconButton(
                              splashRadius: 0.1,
                              onPressed: () async {
                                setState(() {
                                  context
                                      .read<QuestionBloc>()
                                      .add(NextQuestionEvent());
                                });
                                showStat = false;
                              },
                              alignment: Alignment.centerRight,
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: padding * 1.5,
                              ),
                            )
                          : IconButton(
                              splashRadius: 0.1,
                              onPressed: () async {
                                var isTickedTile = false;
                                for (var i in isTicked) {
                                  if (i == true) {
                                    isTickedTile = true;
                                  }
                                }
                                if (!isTickedTile) {
                                  final controller =
                                      Scaffold.of(context).showBottomSheet(
                                    backgroundColor:
                                        const Color.fromARGB(255, 51, 31, 83),
                                    (context) {
                                      return Container(
                                        margin: EdgeInsets.all(padding),
                                        decoration: BoxDecoration(
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  offset: const Offset(0, -2),
                                                  color: Colors.red.shade800)
                                            ],
                                            color: const Color.fromARGB(
                                                255, 46, 27, 77),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    padding * 1.5))),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                      );
                                    },
                                  );
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  controller.close();
                                } else {
                                  setState(() {
                                    showStat = true;
                                  });
                                  context.read<QuestionBloc>().add(
                                      QuestionAnswerEvent(
                                          numberTicked, currentTickedIndex));
                                }
                              },
                              alignment: Alignment.centerRight,
                              icon: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: padding * 1.5,
                              ),
                            ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
