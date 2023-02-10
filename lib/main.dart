import 'dart:math';
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
        home: const Home(),
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: Image.asset('assets/google_icon.png'),
                title: Text('Entrar com Google'),
                onTap: () {
                  FirebaseAuthentication().signInWithGoogle();
                },
              ),
              ListTile(
                leading: Image.asset('assets/apple_icon.png'),
                title: Text('Entrar com Apple'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*      context
                          .read<ProviderLover>()
                          .setLover(mockLovers[Random().nextInt(2)])
                          .then((_) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LobbyScreen(),
                          ),
                        );
                      }); */

List<Lover> mockLovers = [
  Lover(id: 'ela', name: 'She', age: 20),
  Lover(id: 'ele', name: 'He', age: 20)
];
