import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/bloc/question_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MaterialStatesController? statesController;
  TextEditingController questionController = TextEditingController();
  final padding = 18.0;
  bool showStat = false;
  bool isLoaded = false;
  int numberTicked = -1;
  int currentTickedIndex = -1;
  bool isVisiableFAB = false;
  List<bool> isTicked = [];
  List<TextEditingController> answerAddList = [];
  @override
  void initState() {
    super.initState();
    context.read<QuestionBloc>().add(NextQuestionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionBloc, QuestionInitial>(
      builder: (context, state) {
        if (state.question != null) {
          if (isLoaded == false) {
            for (var i = 0; i < state.question!.titels!.length; i++) {
              isTicked.add(false);
            }
            isLoaded = true;
          }
          return Scaffold(
            backgroundColor:
                Theme.of(context).copyWith().scaffoldBackgroundColor,
            floatingActionButton: PopUpMenu(
              context: context,
            ),
            body: Center(
              child: Expanded(
                child: Container(
                  margin: EdgeInsets.all(padding),
                  padding: EdgeInsets.all(padding),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(padding * 1.33)),
                      color: Theme.of(context).scaffoldBackgroundColor),
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${state.question!.question}",
                          maxLines: null,
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
                                onPressed: (!showStat)
                                    ? () {
                                        if (currentTickedIndex != -1 &&
                                            index != currentTickedIndex) {
                                          isTicked[currentTickedIndex] = false;
                                        }
                                        setState(() {
                                          isTicked[index] = !isTicked[index];
                                        });
                                        currentTickedIndex = index;
                                        numberTicked = state.question!.number!;
                                      }
                                    : null,
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty
                                      .all<Color>(isTicked[index]
                                          ? const Color.fromARGB(
                                              255, 117, 46, 233)
                                          : const Color.fromARGB(0, 0, 0, 0)),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.question!.titels![index],
                                    maxLines: null,
                                    overflow: TextOverflow.fade,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      animationDuration: 1500,
                                      percent:
                                          (state.question!.totalResponses! == 0)
                                              ? (state.question!
                                                      .answersAmount![index] /
                                                  (state.question!
                                                          .totalResponses! +
                                                      1))
                                              : (state.question!
                                                      .answersAmount![index] /
                                                  (state.question!
                                                      .totalResponses!)),
                                      progressColor: const Color.fromARGB(
                                          255, 117, 46, 233),
                                      trailing: Text(
                                        "${(state.question!.totalResponses! == 0) ? (100 * (state.question!.answersAmount![index] / (state.question!.totalResponses! + 1))).toStringAsFixed(1) : (100 * (state.question!.answersAmount![index] / (state.question!.totalResponses!))).toStringAsFixed(1)}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
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
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${state.question!.totalResponses!} отв.",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              splashRadius: 0.1,
                              onPressed: () async {
                                if (showStat) {
                                  setState(() {
                                    context
                                        .read<QuestionBloc>()
                                        .add(NextQuestionEvent());
                                    isTicked[currentTickedIndex] = false;
                                  });
                                  showStat = false;
                                } else {
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
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
                                }
                              },
                              alignment: Alignment.centerRight,
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                child: (showStat)
                                    ? const Icon(Icons.check,
                                        color: Colors.white,
                                        key: ValueKey('icon1'))
                                    : const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
              backgroundColor:
                  Theme.of(context).copyWith().scaffoldBackgroundColor,
              body: Downloading(context));
        }
      },
    );
  }
}

class PopUpMenu extends StatelessWidget {
  bool isVisiable = true;
  final BuildContext context;
  PopUpMenu({
    Key? key,
    required this.context,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
            color: (isVisiable)
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
            borderRadius: BorderRadius.circular(18),
            boxShadow: (isVisiable)
                ? [
                    BoxShadow(
                        color: Colors.grey.shade900,
                        blurRadius: 2,
                        spreadRadius: 0)
                  ]
                : []),
        child: PopupMenuButton(
          onOpened: () {
            setState(() {
              isVisiable = false;
            });
          },
          onCanceled: () {
            setState(() {
              isVisiable = true;
            });
          },
          icon: Visibility(
            visible: isVisiable,
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          itemBuilder: ((context) => <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () =>
                      context.read<QuestionBloc>().add(NextQuestionEvent()),
                  child: Row(
                    children: [
                      Icon(
                        Icons.replay_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        " Поменять вопрос",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                    child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    Text(
                      " Информация",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ))
              ]),
        ),
      ),
    );
  }
}

Future<void> showMenu(BuildContext context, double padding) {
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
}

Widget Downloading(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpinKitDoubleBounce(
          size: MediaQuery.of(context).size.width * 0.3,
          color: Colors.white,
        ),
        Text(
          "Загрузка",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  );
}
