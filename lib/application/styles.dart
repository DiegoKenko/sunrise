import 'package:flutter/material.dart';

const kTextLobbyStyle = TextStyle(
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
  letterSpacing: 8,
  color: kPrimaryColor,
);

const kPrimaryColor = Color(0xFFEB7900);

const kTextLoverLobbyStyle = TextStyle(
  fontSize: 18.0,
  letterSpacing: 2,
  color: Colors.white,
);
const kTextLoverRelationshipStyle = TextStyle(
  fontSize: 15.0,
  letterSpacing: 2,
  color: Colors.white,
);

const kTextFormFieldLobbyStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  letterSpacing: 15,
  color: Colors.white,
);

const kTextLeaveLobbyStyle = TextStyle(
  fontSize: 12.0,
  color: Colors.red,
);

const kTextChatMessageStyle = TextStyle(
  fontSize: 17,
  letterSpacing: 1,
  color: Colors.white,
);

const kLobbyLeftBoxDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.white,
      blurRadius: 10,
      offset: Offset(1, -1),
    ),
  ],
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(30),
    bottomRight: Radius.circular(30),
  ),
  color: Colors.white,
);
const kLobbyRightBoxDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: kPrimaryColor,
      blurRadius: 10,
      offset: Offset(1, -1),
    ),
  ],
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30),
    bottomLeft: Radius.circular(30),
  ),
  color: kPrimaryColor,
);

const List<Color> sliderGradientColors = <Color>[
  Color.fromRGBO(250, 120, 0, 1),
  Color.fromRGBO(230, 110, 25, 1),
  Color.fromRGBO(210, 100, 50, 1),
  Color.fromRGBO(190, 90, 75, 1),
  Color.fromRGBO(170, 80, 100, 1),
  Color.fromRGBO(150, 70, 125, 1),
  Color.fromRGBO(130, 60, 150, 1),
  Color.fromRGBO(110, 50, 175, 1),
  Color.fromRGBO(90, 40, 200, 1),
  Color.fromRGBO(70, 30, 225, 1),
  Color.fromRGBO(50, 20, 250, 1),
];
