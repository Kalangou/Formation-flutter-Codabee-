import 'dart:io';

import 'package:app_sqlite/modele/article.dart';
import 'package:app_sqlite/modele/databaseClient.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Ajout extends StatefulWidget {
  late int? id;
  Ajout(int id) {
    this.id = id;
  }
  @override
  _AjoutState createState() => _AjoutState();
}

class _AjoutState extends State<Ajout> {
  late String? image = null;
  late String? nom = null;
  late String? magasin = null;
  late String? prix = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton(
              onPressed: () {
                ajouter();
              },
              child: Text(
                'Valider',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Article à ajouter",
              textScaleFactor: 1.4,
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            ),
            Card(
              elevation: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (image == null)
                      ? Image.asset('images/pas_image.png')
                      : Image.file(File(image ?? '')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          icon: Icon(Icons.camera_enhance)),
                      IconButton(
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          icon: Icon(Icons.photo_library)),
                    ],
                  ),
                  textField(TypeTextField.nom, "Nom de l'article"),
                  textField(TypeTextField.prix, "Prix"),
                  textField(TypeTextField.magasin, "Magasin"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TextField textField(TypeTextField type, String lable) {
    return TextField(
      decoration: InputDecoration(labelText: lable),
      onChanged: (String string) {
        switch (type) {
          case TypeTextField.nom:
            nom = string;
            break;
          case TypeTextField.prix:
            prix = string;
            break;
          case TypeTextField.magasin:
            magasin = string;
            break;
        }
      },
    );
  }

  void ajouter() {
    print("Ajouter");
    if (nom != null) {
      Map<String, dynamic> map = {'nom': nom, 'item': widget.id};
      if (magasin != null) {
        map['magasin'] = magasin;
      }
      if (prix != null) {
        map['prix'] = prix;
      }
      if (image != null) {
        map['image'] = image;
      }

      Article article = Article();
      article.fromMap(map);
      DatabaseClient().upsertArticle(article).then((value) {
        image = null;
        nom = null;
        prix = null;
        magasin = null;
        Navigator.pop(context);
      });
    }
  }

  Future getImage(ImageSource imageSource) async {
    var nouvelleImage = await ImagePicker().pickImage(source: imageSource);
    setState(() {
      image = nouvelleImage?.path;
    });
  }
}

enum TypeTextField { nom, prix, magasin }
