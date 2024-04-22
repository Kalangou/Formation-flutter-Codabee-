import "package:flutter/material.dart";
import "package:quiz_app/widgets/custom_text.dart";
import "package:quiz_app/widgets/page_quiz.dart";

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Card(
              elevation: 9.0,
              child: Container(
                height: MediaQuery.of(context).size.width * 0.8,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset(
                  "quiz asset/cover.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return PageQuiz();
                  }));
                },
                child: CustomText(
                  "Commencer le quiz",
                  factor: 1.5,
                ))
          ],
        ),
      ),
    );
  }
}
