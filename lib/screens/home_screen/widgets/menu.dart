import 'package:flutter/material.dart';
import 'admin_tile.dart';

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
