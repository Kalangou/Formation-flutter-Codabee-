import 'package:app_rss/modele/date_formater.dart';
import 'package:app_rss/widgets/texte_style.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';

class PageDetail extends StatelessWidget {
  PageDetail(RssItem item) {
    this.item = item;
  }
  RssItem item = RssItem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de l'article"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TexteStyle(
              item?.title ?? '',
              fontSize: 30.0,
            ),
            Card(
              elevation: 7.5,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Image.network(
                  item?.enclosure?.url ??
                      'https://s.france24.com/media/display/e1cf79d6-f978-11ee-baff-005056a90284/w:1024/p:16x9/000_34FZ86M-1.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TexteStyle(item.author ?? ''),
                TexteStyle(
                  DateConvertisseur()
                      .convertirDate(item?.pubDate.toString() ?? ''),
                  color: Colors.red,
                )
              ],
            ),
            TexteStyle(item.description ?? '')
          ],
        ),
      ),
    );
  }
}
