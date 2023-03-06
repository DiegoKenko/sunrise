import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sunrise/application/components/animated__page_transition.dart';
import 'package:sunrise/application/screens/screen_lobby.dart';
import 'package:sunrise/domain/bloc_auth.dart';
import 'package:sunrise/domain/firebase_messaging_service.dart';
import 'package:sunrise/domain/notification_service.dart';
import 'package:sunrise/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NotificationService>(
          create: (context) => NotificationService(),
        ),
        Provider<FirebaseMessagingService>(
          create: (context) =>
              FirebaseMessagingService(context.read<NotificationService>()),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc()..add(const AuthEventLogin()),
        child: MaterialApp(
          routes: {
            '/login': (context) => BlocProvider.value(
                  value: BlocProvider.of<AuthBloc>(context),
                  child: const Home(),
                ),
          },
          theme: ThemeData(
            tabBarTheme: const TabBarTheme(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          home: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, AuthState state) {
              if (state.success) {
                Navigator.push(
                  context,
                  AnimatedPageTransition(
                    page: BlocProvider.value(
                      value: BlocProvider.of<AuthBloc>(context),
                      child: const ScreenLobby(),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.success) {
                return Container();
              } else if (state.loading) {
                return Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/main.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                );
              } else {
                return const Home();
              }
            },
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    initilizeFirebaseMessaging();
    checkNotifications();
    super.initState();
  }

  initilizeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false)
        .initialize();
  }

  checkNotifications() async {
    await Provider.of<NotificationService>(context, listen: false)
        .checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/main.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                    width: 70,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
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
                  onTap: () {
                    context.read<AuthBloc>().add(const AuthEventLogin());
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
