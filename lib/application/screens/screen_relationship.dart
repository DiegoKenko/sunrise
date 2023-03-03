import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrise/application/components/tab_chat.dart';
import 'package:sunrise/application/components/tab_mood.dart';
import 'package:sunrise/application/styles.dart';
import 'package:sunrise/domain/bloc_chat.dart';
import 'package:sunrise/domain/bloc_lobby.dart';

class RelationshipScreen extends StatefulWidget {
  const RelationshipScreen({Key? key}) : super(key: key);

  @override
  State<RelationshipScreen> createState() => _RelationshipScreenState();
}

class _RelationshipScreenState extends State<RelationshipScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _key,
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Container(
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: IconButton(
                      onPressed: () => _key.currentState!.openDrawer(),
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TabBar(
                    indicatorColor: Colors.black,
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'humor'),
                      Tab(text: 'chat'),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 18,
              child: TabBarView(
                controller: _tabController,
                children: [
                  const Tab(child: MoodRelationship()),
                  Tab(
                    child: BlocProvider<ChatBloc>(
                      create: (context) => ChatBloc(),
                      child: const TabChat(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodRelationship extends StatefulWidget {
  const MoodRelationship({Key? key}) : super(key: key);
  @override
  State<MoodRelationship> createState() => _MoodRelationshipState();
}

class _MoodRelationshipState extends State<MoodRelationship>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LobbyBloc blocProviderLobby = context.watch<LobbyBloc>();
    final LobbyState state = blocProviderLobby.state;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: TabBar(
              labelColor: Colors.white,
              labelStyle: const TextStyle(
                fontSize: 15,
              ),
              indicator: BoxDecoration(
                color: kPrimaryColor,
                border: Border.all(color: Colors.black, width: 4),
                borderRadius: BorderRadius.circular(30),
              ),
              tabs: [
                Tab(
                  child: Text(
                    state.lobby.lovers[0].name,
                    style: kTextLoverRelationshipStyle,
                  ),
                ),
                Tab(
                  child: Text(
                    state.lobby.lovers[1].name,
                    style: kTextLoverRelationshipStyle,
                  ),
                )
              ],
              controller: _tabController,
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Tab(
                child: TabMood(lover: state.lobby.lovers[0]),
              ),
              Tab(
                child: TabMood(lover: state.lobby.lovers[1]),
              )
            ],
          ),
        ),
      ],
    );
  }
}
