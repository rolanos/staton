import 'package:flutter/material.dart';
import 'package:staton/screens/home_screen/history_screen.dart';
import 'admin_tile.dart';

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
                //История
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        Spacer(),
                        Text(
                          "История",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                PopupMenuDivider(),
                //Информация о проекте
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () => AdminUI.dialogBuilder(context),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        Spacer(),
                        Text(
                          "Информация",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Spacer(),
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
