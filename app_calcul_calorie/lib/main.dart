import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Calculateur de calories'),
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
  late double poids = 0;
  late bool sexe = false;
  late double age = 0;
  late double taille = 160.0;
  late Object? radioSelected = null;
  late int? calorieWithActivity;
  late int calorieBase = 0;
  Map listActivity = {0: 'Faible', 1: 'Moderé', 2: 'Forte'};
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      print("Nous somme sur IOS");
    } else {
      print("Nous somme sur Android");
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: (Platform.isIOS)
          ? CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                backgroundColor: setColor(),
                middle: textData(widget.title),
              ),
              child: body())
          : Scaffold(
              appBar: AppBar(
                backgroundColor: setColor(),
                title: Text(widget.title),
              ),
              body: body()
              // This trailing comma makes auto-formatting nicer for build methods.
              ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          padding(),
          padding(),
          textData(
              "Remplissez tout les champs pour obtenir votre besoin journalier en calorie"),
          padding(),
          Card(
            color: Colors.white,
            elevation: 10.0,
            child: Column(
              children: [
                padding(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    textData("Femme", color: Colors.pink),
                    switchSelonPlatForm(),
                    textData("Home", color: Colors.blue),
                  ],
                ),
                padding(),
                ageButton(),
                padding(),
                textData("Votre taille est de : ${taille.toInt()} cm"),
                padding(),
                sliderSelonPlatForm(),
                padding(),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: "Entrer votre poids en Kilos"),
                  onChanged: (String string) {
                    setState(() {
                      poids = double.tryParse(string) ?? 0;
                    });
                  },
                ),
                padding(),
                textData("Quelle est votre activité sportive",
                    color: setColor()),
                padding(),
                rowRadio(),
                padding(),
              ],
            ),
          ),
          padding(),
          calculButton()
        ],
      ),
    );
  }

  Widget switchSelonPlatForm() {
    if (Platform.isIOS) {
      return CupertinoSwitch(
          value: sexe,
          activeColor: Colors.blue,
          onChanged: (bool b) {
            setState(() {
              sexe = b;
            });
          });
    } else {
      return Switch(
          value: sexe,
          inactiveThumbColor: Colors.pink,
          activeColor: Colors.blue,
          onChanged: (bool b) {
            setState(() {
              sexe = b;
            });
          });
    }
  }

  Widget sliderSelonPlatForm() {
    if (Platform.isIOS) {
      return CupertinoSlider(
        value: taille,
        activeColor: setColor(),
        onChanged: (double d) {
          setState(() {
            taille = d;
          });
        },
        min: 100,
        max: 215,
      );
    } else {
      return Slider(
        value: taille,
        activeColor: setColor(),
        onChanged: (double d) {
          setState(() {
            taille = d;
          });
        },
        min: 100,
        max: 215,
        divisions: 115,
        label: '$taille',
      );
    }
  }

  Widget calculButton() {
    if (Platform.isIOS) {
      return CupertinoButton(
          color: setColor(),
          onPressed: () {
            calculNombreCalories();
          },
          child: textData("Calculer", color: Colors.white));
    } else {
      return OutlinedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => setColor())),
          onPressed: () {
            calculNombreCalories();
          },
          child: textData("Calculer", color: Colors.white));
    }
  }

  Widget ageButton() {
    if (Platform.isIOS) {
      return CupertinoButton(
          color: setColor(),
          child: textData(
              (age == 0)
                  ? "Entrez votre date de naissance"
                  : "Votre age est : ${age.toInt()}",
              color: Colors.white),
          onPressed: () {
            displayDatePicker();
          });
    } else {
      return OutlinedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => setColor())),
          onPressed: () {
            displayDatePicker();
          },
          child: textData(
              (age == 0)
                  ? "Appuyer pour entre votre date de naissance"
                  : "Votre age est : ${age.toInt()}",
              color: Colors.white));
    }
  }

  Future<Null> displayDatePicker() async {
    DateTime? choix = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.year);
    if (choix != null) {
      var difference = DateTime.now().difference(choix);
      var jours = difference.inDays;
      var ans = (jours / 365);
      setState(() {
        age = ans as double;
      });
    }
  }

  Padding padding() {
    return Padding(padding: EdgeInsets.only(top: 20.0));
  }

  Color setColor() {
    if (sexe) {
      return Colors.blue;
    } else {
      return Colors.pink;
    }
  }

  Text textData(data, {color = Colors.black, fontSize = 15.0}) {
    return Text(
      data,
      textAlign: TextAlign.center,
      style: TextStyle(color: color, fontSize: fontSize),
    );
  }

  Row rowRadio<T>() {
    List<Widget> lRow = [];
    listActivity.forEach((key, value) {
      Column colonne = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio<T>(
            value: key,
            groupValue: radioSelected
                as T?, // Assurez-vous que radioSelected est de type T?
            onChanged: (T? newValue) {
              setState(() {
                radioSelected = newValue;
              });
            },
          ),
          textData(value, color: setColor()),
        ],
      );
      lRow.add(colonne);
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: lRow,
    );
  }

  void calculNombreCalories() {
    if (age != null && poids != null && radioSelected != null) {
      if (sexe) {
        calorieBase =
            (66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age))
                .toInt();
      } else {
        calorieBase =
            (655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age))
                .toInt();
      }
      switch (radioSelected) {
        case 0:
          calorieWithActivity = (calorieBase * 1.2).toInt();
          break;
        case 1:
          calorieWithActivity = (calorieBase * 1.5).toInt();
          break;
        case 2:
          calorieWithActivity = (calorieBase * 1.8).toInt();
          break;
        default:
          calorieWithActivity = calorieBase;
          break;
      }
      setState(() {
        dialogue();
      });
    } else {
      // Alerte Erreur
      alerte();
    }
  }

  Future<Null> dialogue() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return SimpleDialog(
            title: textData("Votre besoin en calories", color: setColor()),
            contentPadding: EdgeInsets.all(15.0),
            children: [
              padding(),
              textData("Votre besoin de base est de : ${calorieBase}"),
              padding(),
              textData(
                  "Votre besoin avec activité sportive est de : ${calorieWithActivity}"),
              padding(),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(buildContext);
                },
                child: textData("Fermer", color: Colors.white),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => setColor())),
              )
            ],
          );
        });
  }

  Future<Null> alerte() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: textData("Erreur"),
              content: textData("Tout les champs ne sont pas remplis"),
              actions: [
                CupertinoButton(
                    color: setColor(),
                    child: textData("Fermer", color: Colors.red),
                    onPressed: () {
                      Navigator.pop(buildContext);
                    })
              ],
            );
          } else {
            return AlertDialog(
              title: textData("Erreur"),
              content: textData("Tout les champs ne sont pas remplis"),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(buildContext);
                    },
                    child: textData("Fermer", color: Colors.red))
              ],
            );
          }
        });
  }
}
