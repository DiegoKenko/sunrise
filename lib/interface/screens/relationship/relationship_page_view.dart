import 'package:flutter/material.dart';
import 'package:sunrise/interface/components/drawer/drawer_sunrise.dart';
import 'package:sunrise/interface/screens/relationship/tab_chat.dart';
import 'package:sunrise/interface/screens/relationship/tab_mood.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/interface/controllers/lobby/lobby_controller.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class RelationshipPageView extends StatefulWidget {
  const RelationshipPageView({Key? key}) : super(key: key);

  @override
  State<RelationshipPageView> createState() => _ScreenRelationshipState();
}

class _ScreenRelationshipState extends State<RelationshipPageView>
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
                  children: const [
                    Tab(child: MoodRelationship()),
                    Tab(
                      child: TabChat(),
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
  final LobbyController lobbyController = getIt<LobbyController>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: lobbyController,
      builder: (context, state, _) {
        return Container(
          decoration: kBackgroundDecorationDark,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: TabBar(
                  isScrollable: true,
                  labelColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                  ),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                  indicator: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  indicatorPadding: const EdgeInsets.symmetric(vertical: 5),
                  tabs: [
                    Tab(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          state.lobby.lovers[0].name,
                          style: kTextLoverRelationshipStyle,
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        alignment: Alignment.center,
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
      },
    );
  }
}
