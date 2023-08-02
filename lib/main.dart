import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sunrise/interface/components/animated_page_transition.dart';
import 'package:sunrise/interface/screens/lobby/screen_lobby.dart';
import 'package:sunrise/constants/constants.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/screens/login/login_page_view.dart';
import 'package:sunrise/firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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
            '/login': (context) => const LoginScreenView(),
          },
          onGenerateRoute: (settings) {
            if (!authService.isAuth()) {
              Navigator.pushReplacement(
                context,
                AnimatedPageTransition(
                  page: const LoginScreenView(),
                ),
              );
            }
            return null;
          },
          onGenerateInitialRoutes: (initialRoute) {
            if (authService.isAuth()) {
              return [
                AnimatedPageTransition(
                  page: const ScreenLobby(),
                ),
              ];
            } else {
              return [
                AnimatedPageTransition(
                  page: const LoginScreenView(),
                ),
              ];
            }
          },
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
