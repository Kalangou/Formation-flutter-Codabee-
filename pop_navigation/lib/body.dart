import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyStat createState() => _BodyStat();
}

class _BodyStat extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: (() => dialog(
            "Notification", "Votre opération est effectuée avec succés.")),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.teal),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.white)),
        child: Text(
          'Cliquez-ici',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
        ),
      ),
    );
  }

  // Snackbar
  void snack() {
    SnackBar snackBar = SnackBar(
      content: Text(
        "Je suis une snackbar",
        textScaleFactor: 2,
      ),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Alert dialog
  Future<Null> alerte() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Message d'alerte"),
            content: Text(
                "L'opération que vous tentez d'execuer a echoué. Voulez-vous continuer?"),
            contentPadding: EdgeInsets.all(5.0),
            actions: [
              FloatingActionButton(
                onPressed: () {
                  print("Annuler");
                  Navigator.pop(context);
                },
                child: Text(
                  "Annuler",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  print("Continuer");
                  Navigator.pop(context);
                },
                child: Text(
                  "Continuer",
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ],
          );
        });
  }

  // Simple dialog
  Future<Null> dialog(String titre, String desc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(titre, textScaleFactor: 1.5),
            contentPadding: EdgeInsets.all(10),
            children: [
              Text(desc),
              Container(
                height: 20.0,
              ),
              OutlinedButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.teal),
                  ),
                  onPressed: () {
                    print("Appuyer");
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}
