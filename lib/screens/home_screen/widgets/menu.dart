import 'package:flutter/material.dart';
import 'admin_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/bloc/question_bloc.dart';

///Меню с выбором действий: поменять вопрос, информация о приложении и тд.
class PopUpMenu extends StatelessWidget {
  final BuildContext context;
  PopUpMenu({
    Key? key,
    required this.context,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        height: 58,
        width: 58,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade900, blurRadius: 2, spreadRadius: 0)
            ]),
        child: PopupMenuButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          itemBuilder: ((context) => <PopupMenuEntry>[
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
