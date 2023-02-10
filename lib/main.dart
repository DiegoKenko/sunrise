import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunrise/application/providers/lover_provider.dart';
import 'package:sunrise/application/screens/screen_lobby.dart';
import 'package:sunrise/domain/authentication.dart';
import 'package:sunrise/firebase_options.dart';
import 'package:sunrise/model/model_lover.dart';

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
    return Provider(
      create: (context) => ProviderLover(),
      child: MaterialApp(
        theme: ThemeData(
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuthentication().authStateChanges(),
          builder: (context, snap) {
            if (snap.hasData) {
              context.read<ProviderLover>().setLover(
                    Lover(
                      id: snap.data!.uid,
                      name: snap.data!.displayName!,
                    ),
                  );
              return const LobbyScreen();
            } else {
              return const Home();
            }
          },
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.asset('assets/google_icon.png'),
                title: const Text('Entrar com Google'),
                onTap: () {
                  FirebaseAuthentication().signInWithGoogle().then(
                    (value) {
                      if (value.user != null) {
                        context
                            .read<ProviderLover>()
                            .setLover(
                              Lover(
                                id: value.user!.uid,
                                name: value.user!.displayName!,
                              ),
                            )
                            .then(
                          (_) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LobbyScreen(),
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.asset('assets/apple_icon.png'),
                title: const Text('Entrar com Apple'),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
