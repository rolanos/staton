import 'dart:async';

import 'package:staton/models/question_model.dart';
import 'package:staton/screens/home_screen/widgets/menu.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:staton/logic/question_bloc/question_bloc.dart';

///Главная страница с вопросом пользователю
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  final padding = 18.0;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  TextEditingController questionController = TextEditingController();
  //Показать статистику
  bool showStat = false;
  //true - загружен вопрос
  bool isLoaded = false;
  int numberTicked = -1;
  int currentTickedIndex = -1;

  List<bool> isTicked = [];
  List<TextEditingController> answerAddList = [];

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();
    //При запуске получаем новый вопрос по событию NextQuestionEvent()
    context.read<QuestionBloc>().add(NextQuestionEvent());
    //Прослушиваем все изменения статуса подключения для своевременной перестройки UI
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Установка цвета зажнего фона для Navigation Bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          (MediaQuery.of(context).platformBrightness == Brightness.dark)
              ? const Color.fromARGB(101, 89, 92, 190)
              : Color.fromARGB(232, 7, 6, 45),
      systemStatusBarContrastEnforced: true,
    ));

    return BlocBuilder<QuestionBloc, QuestionInitial>(
      builder: (context, state) {
        //При отсутствие подключения к интернету
        if (_connectionStatus == ConnectivityResult.none) {
          return Scaffold(
              body: _downloading(context, "Нет подключения к интернету"));
        }
        //Получен вопрос от сервера
        if (state.question != null) {
          if (isLoaded == false) {
            isLoaded = true;
          }
          return Scaffold(
            floatingActionButton: PopUpMenu(context: context),
            body: Center(
              child: SwipeTo(
                animationDuration: Duration(milliseconds: 120),
                iconOnRightSwipe: Icons.refresh,
                iconColor: Color.fromARGB(255, 152, 145, 215),
                onRightSwipe: () {
                  context.read<QuestionBloc>().add(NextQuestionEvent());
                  showStat = false;
                  currentTickedIndex = -1;
                  for (var i in isTicked) {
                    i = false;
                  }
                },
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
                      ),
                      ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: state.question!.titels!.length,
                        itemBuilder: (context, index) {
                          for (int i = 0;
                              i < state.question!.titels!.length;
                              i++) {
                            isTicked.add(false);
                          }
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
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
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
                                      lineHeight: 10,
                                      backgroundColor:
                                          Color.fromARGB(255, 152, 145, 215),
                                      animationDuration: 1500,
                                      percent: initPercentIndicator(
                                          state.question,
                                          currentTickedIndex,
                                          index),
                                      progressColor:
                                          Color.fromARGB(255, 139, 81, 255),
                                      trailing: Text(
                                        " ${(state.question!.totalResponses! == 0) ? (index == currentTickedIndex) ? (100 * ((state.question!.answersAmount![index] + 1) / (state.question!.totalResponses! + 1))).toStringAsFixed(1) : (100 * (state.question!.answersAmount![index]) / (state.question!.totalResponses! + 1)).toStringAsFixed(1) : (100 * (state.question!.answersAmount![index] / (state.question!.totalResponses!))).toStringAsFixed(1)}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
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
                                    final snackBar = SnackBar(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      duration:
                                          const Duration(milliseconds: 1400),
                                      content: Center(
                                        child: Text(
                                          "Выберите ответ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    setState(() {
                                      showStat = true;
                                    });
                                    context.read<QuestionBloc>().add(
                                          QuestionAnswerEvent(state.question!,
                                              currentTickedIndex),
                                        );
                                  }
                                }
                              },
                              alignment: Alignment.centerRight,
                              icon: (showStat)
                                  ? const Icon(
                                      Icons.check,
                                    )
                                  : const Icon(
                                      Icons.arrow_forward,
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
          //Загрузка вопроса
          return Scaffold(
              backgroundColor:
                  Theme.of(context).copyWith().scaffoldBackgroundColor,
              body: _downloading(context, "Загрузка"));
        }
      },
    );
  }
}

///Вычисление
double initPercentIndicator(Question? question, int ticked, int index) {
  if (question == null) {
    return -1;
  }
  if (question.totalResponses == 0) {
    if (ticked == index) {
      return (question.answersAmount![index] + 1) /
          (question.totalResponses! + 1);
    } else {
      return (question.answersAmount![index]) / (question.totalResponses! + 1);
    }
  } else {
    return (question.answersAmount![index]) / (question.totalResponses!);
  }
}

///Виджет загрузки вопроса
Widget _downloading(BuildContext context, String text) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SpinKitCircle(
            size: MediaQuery.of(context).size.width * 0.4,
            itemBuilder: (context, index) {
              final colors = [Colors.white, Color.fromARGB(255, 72, 25, 148)];
              final color = colors[index % colors.length];
              return Icon(
                Icons.help,
                color: color,
              );
            },
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  );
}
