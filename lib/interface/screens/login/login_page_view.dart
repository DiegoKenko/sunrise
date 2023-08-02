import 'package:flutter/material.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/components/animated_page_transition.dart';
import 'package:sunrise/interface/screens/lobby/screen_lobby.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';
import 'package:sunrise/services/notification/firebase_messaging_service.dart';
import 'package:sunrise/services/notification/notification_service.dart';

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({Key? key}) : super(key: key);
  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final AuthController authService = getIt<AuthController>();

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
