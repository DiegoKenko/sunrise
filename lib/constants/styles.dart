import 'package:flutter/material.dart';

const kTextLobbyStyle = TextStyle(
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
  letterSpacing: 8,
  color: kPrimaryColor,
);

const kPrimarySwatch = MaterialColor(100, {
  50: Color(0xFFEB7900),
  100: Color(0xFFEB7900),
  200: Color(0xFFEB7900),
  300: Color(0xFFEB7900),
  400: Color(0xFFEB7900),
  500: Color(0xFFEB7900),
  600: Color(0xFFEB7900),
  700: Color(0xFFEB7900),
  800: Color(0xFFEB7900),
  900: Color(0xFFEB7900),
});
const kPrimaryColor = Color(0xFFEB7900);

const k2LevelColor = Color(0xFF16a9c7);

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

const kTextFormFieldChatStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.white,
);
const kTextFormFieldLobbyLabelStyle = TextStyle(
  fontSize: 18.0,
  letterSpacing: 1,
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
  Color.fromRGBO(138, 115, 185, 1),
  Color.fromRGBO(57, 100, 143, 1),
  Color.fromRGBO(60, 120, 120, 1),
  Color.fromRGBO(50, 150, 150, 1),
  Color.fromRGBO(40, 180, 180, 1),
];

const kBackgroundDecorationDark = BoxDecoration(
  gradient: RadialGradient(
    colors: [
      Color.fromARGB(255, 81, 81, 97),
      Color.fromARGB(255, 0, 0, 0),
    ],
    radius: 1.4,
  ),
);
const kBackgroundDecorationLight = BoxDecoration(
  gradient: RadialGradient(
    colors: [
      Color.fromARGB(255, 237, 237, 238),
      Color.fromARGB(255, 168, 167, 167),
    ],
    radius: 1.4,
  ),
);

final kOutlineInputBorder = OutlineInputBorder(
  borderSide: const BorderSide(
    color: Colors.white,
    width: 4,
  ),
  borderRadius: BorderRadius.circular(
    10,
  ),
);

const kDateTimeChatTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.white,
);
