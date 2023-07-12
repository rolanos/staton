import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staton/logic/question_bloc/question_bloc.dart';

Future<void> showThemes(BuildContext context) async {
  context.read<QuestionBloc>().add(GetThemes());
  await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.0),
    ),
    builder: (context) {
      return BlocBuilder<QuestionBloc, QuestionState>(
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(1)),
            child: (state is ChooseThemes)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Выберите темы вопросов",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.themes.length,
                        itemBuilder: (context, index) => ListTile(
                          onTap: () {
                            state.themes[index].iSticked =
                                !state.themes[index].iSticked;
                            context
                                .read<QuestionBloc>()
                                .add(SetThemes(state.themes));
                          },
                          trailing: AnimatedSwitcher(
                            duration: Duration(milliseconds: 600),
                            child: (state.themes[index].iSticked)
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                          ),
                          title: Center(
                            child: Text(
                              state.themes[index].theme,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          style: ButtonStyle(
                              textStyle: MaterialStatePropertyAll(
                                  Theme.of(context).textTheme.bodyMedium),
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 108, 110, 158))),
                          onPressed: () {
                            Navigator.pop(context);
                            context
                                .read<QuestionBloc>()
                                .add(NextQuestionEvent(params: state.themes));
                          },
                          child: Text(
                            "Выбрать темы",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
          );
        },
      );
    },
  ).whenComplete(() => context.read<QuestionBloc>().add(NextQuestionEvent()));
}
