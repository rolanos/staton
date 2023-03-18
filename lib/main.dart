import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import './screens/home_screen.dart';
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
          textTheme: TextTheme(
            titleMedium: const TextStyle(fontSize: 22, color: Colors.white),
            bodyMedium: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            bodySmall: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            labelSmall: TextStyle(color: Colors.grey.shade200, fontSize: 12),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
