import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    _lobbyController.text = 'SGC4nXnzmy04qTrBEFST';

    return BlocProvider<LobbyBloc>(
      create: (context) => LobbyBloc(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: BlocBuilder<LobbyBloc, LobbyState?>(
                builder: (context, lobbyState) {
                  final providerLover = context.read<ProviderLover>();
                  if (lobbyState != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('logged as :${providerLover.lover.name}'),
                        Text('lobby:${lobbyState.lobby.id}'),
                        Text('lover1:${lobbyState.lobby.lovers[0].name}'),
                        Text(
                          'lover2:${lobbyState.lobby.lovers[1].name}',
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
                        TextButton(
                          onPressed: () {
                            LobbyBloc bloc =
                                BlocProvider.of<LobbyBloc>(context);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<LobbyBloc>.value(
                                  value: bloc,
                                  child: const RelationshipScreen(),
                                ),
                              ),
                            );
                          },
                          child: const Text('go to relationship'),
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
                    return const Center(child: Text('Loading...'));
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
