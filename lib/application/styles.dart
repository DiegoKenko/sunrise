import 'package:flutter/material.dart';

final kTextLobbyStyle = TextStyle(
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
  letterSpacing: 8,
  foreground: Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.5
    ..color = Colors.black,
);

final kTextLoverLobbyStyle = TextStyle(
  fontSize: 20.0,
  letterSpacing: 3,
  foreground: Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.5
    ..color = Colors.black,
);

const kTextFormFieldLobbyStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  letterSpacing: 20,
  color: Colors.orange,
);
