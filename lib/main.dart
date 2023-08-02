import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sunrise/interface/screens/lobby/lobby_page_view.dart';
import 'package:sunrise/constants/constants.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/screens/login/login_page_view.dart';
import 'package:sunrise/firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sunrise/interface/screens/relationship/relationship_page_view.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublicKeyLive;
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final authService = getIt<AuthController>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, state, child) {
        return MaterialApp(
          routes: {
            '/login': (context) => const LoginPageView(),
            '/lobby': (context) => const LobbyPageView(),
            '/relationship': (context) => const RelationshipPageView(),
          },
          home: const LoginPageView(),
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
            splashColor: kPrimaryColor,
            useMaterial3: true,
            primarySwatch: kPrimarySwatch,
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor,
              secondary: Colors.black,
            ),
            fontFamily: GoogleFonts.sono().fontFamily,
            tabBarTheme: const TabBarTheme(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
