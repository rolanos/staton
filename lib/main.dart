import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staton/logic/history_bloc/history_bloc.dart';
import 'package:staton/screens/main_screen.dart';
import 'firebase_options.dart';
import 'screens/home_screen/history_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'logic/question_bloc/question_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});
  int pageIndex = 0;
  final List<Widget> screens = <Widget>[HomePage(), HistoryScreen()];
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuestionBloc>(
          create: (context) => QuestionBloc(),
        ),
        BlocProvider<HistoryBloc>(create: (context) => HistoryBloc())
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          buttonTheme: ButtonThemeData(
            highlightColor: Color.fromARGB(200, 64, 38, 166),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(105, 31, 21, 93),
            selectedIconTheme: IconThemeData(color: Colors.white),
            unselectedIconTheme: IconThemeData(color: Colors.grey.shade600),
            selectedLabelStyle:
                GoogleFonts.roboto(fontSize: 14, color: Colors.white),
            unselectedLabelStyle:
                GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade600),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey.shade600,
          ),
          dialogBackgroundColor: Color.fromARGB(255, 56, 53, 114),
          dividerTheme: DividerThemeData(
              thickness: 0.5, color: const Color.fromARGB(255, 228, 255, 248)),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color.fromARGB(255, 72, 25, 148),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
          ),
          scaffoldBackgroundColor: Color.fromARGB(100, 64, 68, 168),
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
            //texts like question
            titleMedium: GoogleFonts.roboto(fontSize: 22, color: Colors.white),
            //texts like amount of answers
            titleSmall: GoogleFonts.roboto(
                fontSize: 12, color: Color.fromARGB(82, 255, 254, 254)),
            //texts like answers for question
            bodyMedium: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 18,
            ),
            //texts like value of procent
            bodySmall: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        home: MainScreen(),
      ),
    );
  }
}
