import 'package:app_rss/modele/parser.dart';
import 'package:app_rss/widgets/chargement.dart';
import 'package:app_rss/widgets/grille.dart';
import 'package:app_rss/widgets/liste.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late RssFeed rssFeed = RssFeed();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    parse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    rssFeed = RssFeed();
                    parse();
                  });
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: choixBody());
  }

  Widget choixBody() {
    if (rssFeed == null) {
      return Chargement();
    } else {
      Orientation orientation = MediaQuery.of(context).orientation;
      if (orientation == Orientation.portrait) {
        // Liste
        return Liste(rssFeed);
      } else {
        // Liste
        return Grille(rssFeed);
      }
    }
  }

  Future<Null> parse() async {
    final url = "http://www.france24.com/fr/actualites/rss";

    RssFeed receive = await Parser().chargerRSS(url);
    print(receive);
    if (receive != null) {
      setState(() {
        rssFeed = receive;
        print("Taille des données : ${rssFeed.items?.length}");
        rssFeed.items?.forEach((rssItem) {
          RssItem item = rssItem;
          print(item.author);
          print(item.title);
          print(item.description);
          print(item.pubDate);
          print(item.enclosure?.url);
        });
      });
    }
  }
}
