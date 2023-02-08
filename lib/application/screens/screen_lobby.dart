import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunrise/application/providers/lover_provider.dart';
import 'package:sunrise/application/screens/screen_relationship.dart';
import 'package:sunrise/domain/cubit_lobby.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({Key? key}) : super(key: key);
  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final TextEditingController _lobbyController = TextEditingController();
  bool jumpToRelationShip = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1));
      jumpToRelationShip ? route() : null;
    });
  }

  route() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RelationShipScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    _lobbyController.text = '87zobTjrk8XQJxUP8GOm';
    return Consumer<ProviderLover>(
      builder: (context, providerLover, child) {
        final lobbyCubit = LobbyCubit(providerLover.lover);
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: StreamBuilder<LobbyState?>(
                  stream: lobbyCubit.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      jumpToRelationShip =
                          snapshot.data!.status == LobbyStatus.sucessReady;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('lobby:${snapshot.data!.lobby.id}'),
                          Text('lover1:${snapshot.data!.lobby.lover1.name}'),
                          Text(
                            snapshot.data!.lobby.lover2 == null
                                ? 'lover2:'
                                : 'lover2:${snapshot.data!.lobby.lover2!.name}',
                          ),
                          TextField(
                            controller: _lobbyController,
                            decoration: const InputDecoration(
                              hintText: 'Enter lobby id',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              lobbyCubit.joinLobby(
                                _lobbyController.text,
                                providerLover.lover,
                              );
                            },
                            child: const Text('join'),
                          ),
                          Text(snapshot.data!.status.description)
                        ],
                      );
                    } else {
                      return const Text('Loading...');
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
