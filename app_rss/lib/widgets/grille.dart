import 'package:app_rss/modele/date_formater.dart';
import 'package:app_rss/widgets/page_details.dart';
import 'package:app_rss/widgets/texte_style.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';

class Grille extends StatefulWidget {
  RssFeed rssFeed = RssFeed();
  Grille(RssFeed rssFeed) {
    this.rssFeed = rssFeed;
  }

  @override
  _GrilleState createState() => _GrilleState();
}

class _GrilleState extends State<Grille> {
  @override
  Widget build(BuildContext context) {
    var taille = MediaQuery.of(context).size.width / 2.5;
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: widget.rssFeed.items?.length,
        itemBuilder: (context, i) {
          RssItem? item = widget.rssFeed.items?[i];
          return InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return PageDetail(item!);
              }));
            },
            child: Card(
              elevation: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  padding(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TexteStyle(item?.author ?? ''),
                      TexteStyle(
                        DateConvertisseur()
                            .convertirDate(item?.pubDate.toString() ?? ''),
                        color: Colors.red,
                      )
                    ],
                  ),
                  padding(),
                  TexteStyle(item?.title ?? ''),
                  Card(
                    elevation: 7.5,
                    child: Container(
                      width: taille,
                      child: Image.network(
                        item?.enclosure?.url ??
                            'https://s.france24.com/media/display/e1cf79d6-f978-11ee-baff-005056a90284/w:1024/p:16x9/000_34FZ86M-1.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  padding()
                ],
              ),
            ),
          );
        });
  }

  Padding padding() {
    return Padding(padding: EdgeInsets.only(top: 10));
  }
}
