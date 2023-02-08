import 'package:flutter/material.dart';

class RelationShipScreen extends StatefulWidget {
  const RelationShipScreen({Key? key}) : super(key: key);
  @override
  State<RelationShipScreen> createState() => _RelationShipScreenState();
}

class _RelationShipScreenState extends State<RelationShipScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
            child: TextButton(onPressed: () {}, child: const Text('leave')),
          ),
        ],
      )),
    );
  }
}
