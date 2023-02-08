import 'package:flutter/material.dart';
import 'package:sunrise/data/mock_moods.dart';

class RelationShipScreen extends StatefulWidget {
  const RelationShipScreen({Key? key}) : super(key: key);
  @override
  State<RelationShipScreen> createState() => _RelationShipScreenState();
}

class _RelationShipScreenState extends State<RelationShipScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                itemBuilder: (context, index) {
                  return null;
                },
                itemCount: mockMoodMatching.length,
              )
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: const [
              Tab(
                child: Text('My Mood'),
              ),
            ],
            controller: _tabController,
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  child:
                      TextButton(onPressed: () {}, child: const Text('leave')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
