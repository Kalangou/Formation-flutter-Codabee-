import 'package:flutter/material.dart';

class DonneesVides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Aucune donnée disponible...",
        textScaleFactor: 2.0,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
      ),
    );
  }
}
