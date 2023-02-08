import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunrise/application/providers/lover_provider.dart';
import 'package:sunrise/application/screens/screen_lobby.dart';
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
      child: const MaterialApp(
        home: Home(),
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
              SizedBox(
                height: 500,
                width: 100,
                child: Center(
                  child: TextButton(
                    onPressed: () async {
                      context
                          .read<ProviderLover>()
                          .setLover(mockLovers[Random().nextInt(2)])
                          .then((_) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LobbyScreen(),
                          ),
                        );
                      });
                    },
                    child: const Text('login'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Lover> mockLovers = [
  Lover(id: 'ela', name: 'She', age: 20),
  Lover(id: 'ele', name: 'He', age: 20)
];
