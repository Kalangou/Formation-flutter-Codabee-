import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/home.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Quizz vrai ou faux '),
      debugShowCheckedModeBanner: false,
    );
  }
}
