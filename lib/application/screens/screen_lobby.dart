import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunrise/application/providers/lover_provider.dart';
import 'package:sunrise/application/screens/screen_relationship.dart';
import 'package:sunrise/domain/bloc_lobby.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      //jumpToRelationShip ? route() : null;
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
    _lobbyController.text = 'I4xk1lTV14cgn3Pm7O5F';
    return Consumer<ProviderLover>(
      builder: (context, providerLover, child) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: BlocBuilder<LobbyBloc, LobbyState?>(
                  builder: (context, lobbyState) {
                    if (lobbyState != null) {
                      jumpToRelationShip =
                          lobbyState.status == LobbyStatus.sucessReady;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('lobby:${lobbyState.lobby.id}'),
                          Text('lover1:${lobbyState.lobby.lover1.name}'),
                          Text(
                            lobbyState.lobby.lover2 == null
                                ? 'lover2:'
                                : 'lover2:${lobbyState.lobby.lover2!.name}',
                          ),
                          TextField(
                            controller: _lobbyController,
                            decoration: const InputDecoration(
                              hintText: 'Enter lobby id',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<LobbyBloc>().add(
                                    LobbyEventJoin(
                                      lobbyId: _lobbyController.text,
                                      lover: providerLover.lover,
                                    ),
                                  );
                            },
                            child: const Text('join'),
                          ),
                          Text(lobbyState.status.description),
                          TextButton(
                            onPressed: () {
                              context.read<LobbyBloc>().add(
                                    LobbyEventLeave(
                                      lobbyId: _lobbyController.text,
                                      lover: providerLover.lover,
                                    ),
                                  );
                            },
                            child: const Text('leave'),
                          ),
                        ],
                      );
                    } else {
                      context.read<LobbyBloc>().add(
                            LobbyEventLoad(
                              lobbyId: providerLover.lover.lobbyId,
                              lover: providerLover.lover,
                            ),
                          );
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
