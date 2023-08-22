import 'package:flutter/material.dart';
import 'package:sunrise/interface/screens/lobby/lobby_page_view.dart';
import 'package:sunrise/interface/screens/login/login_page_view.dart';
import 'package:sunrise/interface/screens/relationship/relationship_page_view.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/login': (context) => const LoginPageView(),
    '/lobby': (context) => const LobbyPageView(),
    '/relationship': (context) => const RelationshipPageView(),
  };

  static String initial = '/home';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
