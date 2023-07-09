import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staton/logic/question_bloc/question_bloc.dart';
import 'home_screen/history_screen.dart';
import 'home_screen/home_screen.dart';
import 'home_screen/widgets/admin_tile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> screens = <Widget>[HomePage(), HistoryScreen()];
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (pageIndex == 0)
          ? AppBar(
              leading: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                  ),
                  splashRadius: 18,
                  highlightColor: Color.fromARGB(200, 64, 38, 166),
                ),
              ),
              actions: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () async => await AdminUI.dialogBuilder(context),
                    icon: Icon(Icons.info_outline_rounded),
                    splashRadius: 18,
                    highlightColor: Color.fromARGB(200, 64, 38, 166),
                  ),
                ),
              ],
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: (pageIndex == 0)
          ? Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                height: 64,
                width: 64,
                child: FloatingActionButton(
                  onPressed: () =>
                      context.read<QuestionBloc>().add(NextQuestionEvent()),
                  splashColor: Color.fromARGB(255, 139, 81, 255),
                  hoverColor: Color.fromARGB(255, 63, 37, 114),
                  backgroundColor: Color.fromARGB(255, 139, 81, 255),
                  child: Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Color.fromARGB(199, 41, 30, 83), width: 8),
                      ),
                      child: Icon(Icons.refresh)),
                ),
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) => setState(() => pageIndex = value),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.question_mark), label: 'Вопрос'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'История'),
        ],
      ),
      body: screens[pageIndex],
    );
  }
}
