import 'dart:io';

import 'package:app_sqlite/modele/article.dart';
import 'package:app_sqlite/modele/databaseClient.dart';
import 'package:app_sqlite/modele/item.dart';
import 'package:app_sqlite/widgets/ajout_article.dart';
import 'package:app_sqlite/widgets/donnees_vides.dart';
import 'package:flutter/material.dart';

class ItemDetails extends StatefulWidget {
  late Item? item;
  ItemDetails(Item item) {
    this.item = item;
  }

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  List<Article>? articles;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseClient().allArticle(widget.item?.id ?? 0).then((liste) {
      setState(() {
        articles = liste;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.item?.nom ?? 'Détails'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext buildContext) {
                  return Ajout(widget.item?.id ?? 0);
                })).then((value) {
                  DatabaseClient()
                      .allArticle(widget.item?.id ?? 0)
                      .then((liste) {
                    setState(() {
                      articles = liste;
                    });
                  });
                });
              },
              child: Text(
                'Ajouter',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: (articles == null || articles?.length == 0)
          ? DonneesVides()
          : GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
              itemCount: articles?.length,
              itemBuilder: (context, i) {
                Article article = articles![i];
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        article.nom ?? '',
                        textScaleFactor: 1.4,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 3.5,
                        child: (article.image == null)
                            ? Image.asset(
                                'images/pas_image.png',
                                fit: BoxFit.cover,
                              )
                            : Image.file(File(article.image!)),
                      ),
                      Text((article.prix == null)
                          ? 'Aucun prix renseigné'
                          : 'Prix : ${article.prix}'),
                      Text((article.magasin == null)
                          ? 'Aucun magasin renseigné'
                          : "Magasin : ${article.magasin}"),
                    ],
                  ),
                );
              }),
    );
  }
}
