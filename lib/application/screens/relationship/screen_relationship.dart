import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrise/application/components/drawer_sunrise.dart';
import 'package:sunrise/application/components/tab_chat.dart';
import 'package:sunrise/application/components/tab_mood.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/domain/chat/bloc_chat.dart';
import 'package:sunrise/domain/lobby/bloc_lobby.dart';

class ScreenRelationship extends StatefulWidget {
  const ScreenRelationship({Key? key}) : super(key: key);

  @override
  State<ScreenRelationship> createState() => _ScreenRelationshipState();
}

class _ScreenRelationshipState extends State<ScreenRelationship>
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
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _key,
          drawer: const SunriseDrawer(),
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
                    flex: 5,
                    child: TabBar(
                      indicatorColor: Colors.black,
                      controller: _tabController,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Emoções',
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Image.asset(
                                  'assets/emotions_icon.gif',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Mensagens',
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Image.asset(
                                  'assets/chat_icon.gif',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
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

    return Container(
      decoration: kBackgroundDecorationDark,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
            child: TabBar(
              isScrollable: true,
              labelColor: Colors.white,
              labelStyle: const TextStyle(
                fontSize: 15,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              indicator: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(15),
              ),
              tabs: [
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      state.lobby.lovers[0].name,
                      style: kTextLoverRelationshipStyle,
                    ),
                  ),
                ),
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      state.lobby.lovers[1].name,
                      style: kTextLoverRelationshipStyle,
                    ),
                  ),
                )
              ],
              controller: _tabController,
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
      ),
    );
  }
}
