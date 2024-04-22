import 'package:app_rss/widgets/texte_style.dart';
import 'package:flutter/material.dart';

class Chargement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TexteStyle(
        "Chargement en cours...",
        fontStyle: FontStyle.italic,
        fontSize: 30.0,
      ),
    );
  }
}
