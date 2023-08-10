import 'package:flutter/material.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/components/animated_page_transition.dart';
import 'package:sunrise/interface/screens/lobby/lobby_page_view.dart';
import 'package:sunrise/interface/states/auth_state.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';
import 'package:sunrise/services/notification/firebase_messaging_service.dart';
import 'package:sunrise/services/notification/notification_service.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({Key? key}) : super(key: key);
  @override
  State<LoginPageView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginPageView> {
  final AuthController authController = getIt<AuthController>();

  @override
  void initState() {
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
                ValueListenableBuilder(
                  valueListenable: authController,
                  builder: (context, state, _) {
                    Widget accountButton = Row(
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
                    );

                    if (state is AuthLoadingState) {
                      accountButton = const Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                          strokeWidth: 5,
                        ),
                      );
                    }

                    if (state is AuthAuthenticatedState) {
                      accountButton = TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                            kPrimaryColor,
                          ),
                          elevation: MaterialStateProperty.all(10),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          animationDuration: const Duration(milliseconds: 500),
                        ),
                        child: const Center(
                          child: Text(
                            'Iniciar',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pushReplacement(
                            context,
                            AnimatedPageTransition(
                              page: const LobbyPageView(),
                            ),
                          );
                        },
                      );
                    }

                    return Container(
                      width: 140,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                            kPrimaryColor,
                          ),
                          elevation: MaterialStateProperty.all(10),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          animationDuration: const Duration(milliseconds: 500),
                        ),
                        child: accountButton,
                        onPressed: () async {
                          authController.login();
                        },
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
