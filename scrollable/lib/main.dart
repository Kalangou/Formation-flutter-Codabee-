import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Le scrollable'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Activite> listActivity = [
    Activite('Vélo', Icons.directions_bike),
    Activite('Peinture', Icons.palette),
    Activite('Golf', Icons.golf_course),
    Activite('Arcade', Icons.gamepad),
    Activite('Bricolage', Icons.build),
    Activite('Etudiant', Icons.person),
    Activite('Livre', Icons.book),
    Activite('Paramétre', Icons.settings),
    Activite('Vélo', Icons.directions_bike),
    Activite('Peinture', Icons.palette),
    Activite('Golf', Icons.golf_course),
    Activite('Arcade', Icons.gamepad),
    Activite('Bricolage', Icons.build),
    Activite('Etudiant', Icons.person),
    Activite('Livre', Icons.book),
    Activite('Paramétre', Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
            child: (orientation == Orientation.portrait) ? liste() : griew()));
  }

  Widget liste() {
    return ListView.builder(
        itemCount: listActivity.length,
        itemBuilder: (context, i) {
          Activite activite = listActivity[i];
          String key = activite.nom;
          return Dismissible(
            key: Key(key),
            child: Container(
              height: 125,
              child: Card(
                  elevation: 7.5,
                  child: InkWell(
                    onTap: (() => print("Tapped")),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            activite.icon,
                            color: Colors.teal,
                            size: 75,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Activité: ",
                                style:
                                    TextStyle(color: Colors.teal, fontSize: 20),
                              ),
                              Text(
                                activite.nom,
                                style: TextStyle(
                                    color: Colors.teal[700], fontSize: 30),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
            ),
            background: Container(
              padding: EdgeInsets.only(right: 20.0),
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Supprimer",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                print(activite.nom);
                listActivity.removeAt(i);
              });
            },
          );
        });
  }

  Widget griew() {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemCount: listActivity.length,
        itemBuilder: (context, i) {
          Activite activite = listActivity[i];
          return Container(
            margin: EdgeInsets.all(3),
            child: Card(
                elevation: 10,
                child: InkWell(
                  onTap: (() => print("Tapped Grille")),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Activité : ",
                        style: TextStyle(color: Colors.teal, fontSize: 15),
                      ),
                      Icon(
                        activite.icon,
                        color: Colors.teal,
                        size: 40,
                      ),
                      Text(
                        activite.nom,
                        style: TextStyle(
                            color: Colors.teal[800],
                            fontSize: 20,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}

class Activite {
  late String nom;
  late IconData icon;

  Activite(String nom, IconData icon) {
    this.nom = nom;
    this.icon = icon;
  }
}
