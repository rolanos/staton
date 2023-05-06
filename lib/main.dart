import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'screens/home_screen/home_screen.dart';
import './logic/bloc/question_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuestionBloc(),
      child: MaterialApp(
        theme: ThemeData(
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
          scaffoldBackgroundColor: const Color.fromARGB(101, 89, 92, 190),
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
            //texts like question
            titleMedium: const TextStyle(fontSize: 22, color: Colors.white),
            //texts like amount of answers
            titleSmall: const TextStyle(
                fontSize: 12, color: Color.fromARGB(82, 255, 254, 254)),
            //texts like answers for question
            bodyMedium: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            //texts like value of procent
            bodySmall: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
