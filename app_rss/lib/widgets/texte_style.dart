import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TexteStyle extends Text {
  TexteStyle(String data,
      {textAlign = TextAlign.center,
      color = Colors.indigo,
      fontSize = 15.0,
      fontStyle = FontStyle.normal})
      : super(data,
            textAlign: textAlign,
            style: TextStyle(
                color: color, fontSize: fontSize, fontStyle: fontStyle)) {}
}
