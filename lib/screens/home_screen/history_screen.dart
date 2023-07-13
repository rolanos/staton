import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staton/logic/history_bloc/history_bloc.dart';
import 'package:staton/models/answer_model.dart';
import 'package:staton/models/db_model.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});
  final DBConnect db = DBConnect();

  @override
  Widget build(BuildContext context) {
    int lastTickedCard = 0;
    TextEditingController controller = TextEditingController();
    List<bool> showInfo = [];
    ScrollController scrollController = ScrollController();

    context.read<HistoryBloc>().add(GetAllHistoryEvent());

    return FutureBuilder(
      future: db.open(),
      builder: (context, _) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              List<Answer>? data = state.list;

              if (data == null) {
                return Center(
                  child: Text("Нет данных"),
                );
              }
              if (showInfo.length != data.length) {
                for (int i = 0; i < data.length; i++) {
                  showInfo.add(false);
                }
              }
              return SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "История ответов",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Найти вопрос",
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.white),
                          contentPadding: EdgeInsets.all(8.0),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          focusColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 69, 65, 175),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 141, 112, 170),
                                width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Color.fromARGB(255, 74, 51, 146),
                          filled: true,
                        ),
                        onChanged: (value) {
                          for (var i = 0; i < showInfo.length; i++) {
                            showInfo[i] = false;
                          }
                          context.read<HistoryBloc>().add(
                              SearchHistoryEvent(query: controller.value.text));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: const Divider(
                        height: 1,
                      ),
                    ),
                    ListView.builder(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              showInfo[index] = !showInfo[index];
                              if (lastTickedCard != index) {
                                if (lastTickedCard != -1)
                                  showInfo[lastTickedCard] = false;
                                lastTickedCard = index;
                              }

                              context
                                  .read<HistoryBloc>()
                                  .add(GetQuestionInfoEvent(data[index].id));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 104, 43, 201),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Divider(
                                            thickness: 2,
                                          ),
                                        )
                                      : SizedBox(),
                                  (showInfo[index])
                                      ? SizedBox(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: state.shownQuestion!
                                                  .titels!.length,
                                              itemBuilder: (_, i) {
                                                return Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        state.shownQuestion!
                                                            .titels![i],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                      Text(
                                                        "${(100 * state.shownQuestion!.answersAmount![i] / state.shownQuestion!.totalResponses!).toStringAsFixed(1)}%",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
