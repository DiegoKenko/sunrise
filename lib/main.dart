import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sunrise/application/components/animated_page_transition.dart';
import 'package:sunrise/application/screens/lobby/screen_lobby.dart';
import 'package:sunrise/constants/constants.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/domain/auth/auth_notifier.dart';
import 'package:sunrise/services/notification/firebase_messaging_service.dart';
import 'package:sunrise/services/notification/notification_service.dart';
import 'package:sunrise/firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublicKeyLive;
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = getIt<AuthService>();
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, state, child) {
        return MaterialApp(
          routes: {
            '/login': (context) => const Home(),
          },
          onGenerateRoute: (settings) {
            if (!authService.isAuth()) {
              Navigator.pushReplacement(
                context,
                AnimatedPageTransition(
                  page: const Home(),
                ),
              );
            }
            return null;
          },
          onGenerateInitialRoutes: (initialRoute) {
            final AuthService authService = getIt<AuthService>();
            if (authService.isAuth()) {
              return [
                AnimatedPageTransition(
                  page: const ScreenLobby(),
                ),
              ];
            } else {
              return [
                AnimatedPageTransition(
                  page: const Home(),
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

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService authService = getIt<AuthService>();

  @override
  void initState() {
    authService.authenticate();
    initilizeFirebaseMessaging();
    checkNotifications();
    super.initState();
  }

  initilizeFirebaseMessaging() async {
    FirebaseMessagingService firebaseMessagingService =
        getIt<FirebaseMessagingService>();
    firebaseMessagingService.initialize();
  }

  checkNotifications() async {
    NotificationService notificationService = getIt<NotificationService>();
    notificationService.checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        key: const Key('loginGoogleButton '),
        decoration: const BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
            image: AssetImage('assets/background_login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    width: 140,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/google_icon.png'),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text('Entrar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    if (!authService.isAuth()) {
                      await authService.authenticate();
                    }
                    Navigator.pushReplacement(
                      context,
                      AnimatedPageTransition(
                        page: const ScreenLobby(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
