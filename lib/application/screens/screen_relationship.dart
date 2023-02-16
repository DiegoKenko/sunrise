import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrise/application/components/tab_chat.dart';
import 'package:sunrise/application/components/tab_emotions_feed.dart';
import 'package:sunrise/application/components/tab_mood.dart';
import 'package:sunrise/domain/bloc_lobby.dart';
import 'package:sunrise/model/model_lover.dart';

class RelationshipScreen extends StatefulWidget {
  const RelationshipScreen({Key? key}) : super(key: key);
  @override
  State<RelationshipScreen> createState() => _RelationshipScreenState();
}

class _RelationshipScreenState extends State<RelationshipScreen>
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

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: TabBarView(
            controller: _tabController,
            children: [
              Tab(
                child: LoverPanel(lover: state.lobby.lovers[0]),
              ),
              Tab(
                child: LoverPanel(lover: state.lobby.lovers[1]),
              )
            ],
          ),
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              child: Text(state.lobby.lovers[0].name),
            ),
            Tab(
              child: Text(state.lobby.lovers[1].name),
            )
          ],
          controller: _tabController,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: TextButton(onPressed: () {}, child: const Text('leave')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoverPanel extends StatefulWidget {
  const LoverPanel({
    super.key,
    required this.lover,
  });
  final Lover lover;

  @override
  State<LoverPanel> createState() => _LoverPanelState();
}

class _LoverPanelState extends State<LoverPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'emotions'),
            Tab(text: 'humor'),
            Tab(text: 'chat'),
          ],
        ),
        Expanded(
          flex: 9,
          child: TabBarView(
            controller: _tabController,
            children: [
              const Tab(child: TabEmotionsFeed()),
              Tab(
                child: TabMood(lover: widget.lover),
              ),
              const Tab(child: TabChat()),
            ],
          ),
        ),
      ],
    );
  }
}

class CouplePanel extends StatefulWidget {
  const CouplePanel({
    super.key,
  });

  @override
  State<CouplePanel> createState() => _CouplePanelState();
}

class _CouplePanelState extends State<CouplePanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LobbyBloc blocProviderLobby = context.watch<LobbyBloc>();
    final LobbyState state = blocProviderLobby.state;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'emotions'),
            Tab(text: 'humor'),
            Tab(text: 'chat'),
          ],
        ),
        Expanded(
          flex: 9,
          child: TabBarView(
            controller: _tabController,
            children: const [
              Tab(text: 'emotions'),
              Tab(text: 'humor'),
              Tab(text: 'chat'),
            ],
          ),
        ),
      ],
    );
  }
}
