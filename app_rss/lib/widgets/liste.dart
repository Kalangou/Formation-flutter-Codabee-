import 'package:app_rss/modele/date_formater.dart';
import 'package:app_rss/widgets/page_details.dart';
import 'package:app_rss/widgets/texte_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webfeed/webfeed.dart';

class Liste extends StatefulWidget {
  late RssFeed rssFeed;
  Liste(RssFeed rssFeed) {
    this.rssFeed = rssFeed;
  }

  @override
  _ListeState createState() => _ListeState();
}

class _ListeState extends State<Liste> {
  @override
  Widget build(BuildContext context) {
    final taille = MediaQuery.of(context).size.width / 2.5;
    return ListView.builder(
        itemCount: widget.rssFeed.items?.length,
        itemBuilder: (context, i) {
          RssItem? item = widget.rssFeed.items?[i];
          return Container(
              child: Card(
                  elevation: 10,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return PageDetail(item!);
                      }));
                    },
                    child: Column(
                      children: [
                        padding(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TexteStyle(item?.author ?? ''),
                            TexteStyle(
                              DateConvertisseur().convertirDate(
                                  item?.pubDate.toString() ?? ''),
                              color: Colors.red,
                            )
                          ],
                        ),
                        padding(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                            Container(
                              width: taille,
                              child: TexteStyle(item?.title ?? ''),
                            )
                          ],
                        ),
                        padding(),
                      ],
                    ),
                  )),
              padding: EdgeInsets.only(right: 5.0, left: 5.0));
        });
  }

  Padding padding() {
    return Padding(padding: EdgeInsets.only(top: 10.0));
  }
}
