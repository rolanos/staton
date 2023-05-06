import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'admin_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/bloc/question_bloc.dart';

///Меню с выбором действий: поменять вопрос, информация о приложении и тд.
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
                ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75)
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
                  child: GestureDetector(
                    onTap: () => AdminUI.dialogBuilder(context),
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
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
