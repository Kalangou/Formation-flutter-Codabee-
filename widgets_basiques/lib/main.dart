import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Les widgets basiques",
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home_();
  }
}

class _Home_ extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page d'accueil"),
        leading: Icon(Icons.account_circle),
        actions: [
          Icon(Icons.access_alarm),
          Icon(Icons.golf_course),
          Icon(Icons.directions_bike),
        ],
        elevation: 20.0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blue,
        margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Center(
            child: Card(
          elevation: 10.0,
          color: Colors.black,
          child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 250,
              child: Image.asset(
                'images/bee.jpg',
                fit: BoxFit.cover,
              )),
        )),
      ),
    );
  }
}
