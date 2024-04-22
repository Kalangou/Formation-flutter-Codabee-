import 'package:app_sqlite/modele/databaseClient.dart';
import 'package:app_sqlite/modele/item.dart';
import 'package:app_sqlite/widgets/donnees_vides.dart';
import 'package:app_sqlite/widgets/item_details.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeController extends StatefulWidget {
  const HomeController({super.key, required this.title});
  final String title;

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  late String? nouvelleListe;
  List<Item> items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            TextButton(
                onPressed: () {
                  dialog(null);
                },
                child: Text(
                  "Ajouter",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: (items == null || items.length == 0)
            ? DonneesVides()
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  Item item = items[i];
                  return ListTile(
                    title: Text(item.nom.toString()),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        DatabaseClient().delete(item.id!, 'item').then((int) {
                          print("L'ID récuperé est : ${int}");
                          recuperer();
                        });
                      },
                    ),
                    leading: IconButton(
                        onPressed: (() => dialog(item)),
                        icon: Icon(Icons.edit)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext buildContext) {
                        return ItemDetails(item);
                      }));
                    },
                  );
                }));
  }

  Future<Null> dialog(Item? item) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext buildContect) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Nouvelle liste"),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Liste : ",
                  hintText:
                      (item == null) ? "Ex: Prochain jeux vidéos" : item!.nom),
              onChanged: (String str) {
                nouvelleListe = str;
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(buildContect);
                  },
                  child: Text('Annuler')),
              TextButton(
                  onPressed: () {
                    if (nouvelleListe != null) {
                      if (item == null) {
                        item = Item();
                        // Fonction d'enregistrement
                        Map<String, dynamic> map = {'nom': nouvelleListe};
                        item?.fromMap(map);
                      } else {
                        item?.nom = nouvelleListe;
                      }

                      DatabaseClient()
                          .upsertItem(item!)
                          .then((i) => recuperer());
                      nouvelleListe = null;
                    }
                    Navigator.pop(buildContect);
                  },
                  child: Text(
                    "Valider",
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          );
        });
  }

  void recuperer() {
    DatabaseClient().allItem().then((items) {
      setState(() {
        this.items = items;
      });
    });
  }
}
