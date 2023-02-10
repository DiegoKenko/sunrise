import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return BlocProvider<LobbyBloc>(
      create: (context) => LobbyBloc(),
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: BlocBuilder<LobbyBloc, LobbyState?>(
              builder: (context, lobbyState) {
                final providerLover = context.read<ProviderLover>();
                if (lobbyState != null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('logged as :${providerLover.lover.name}'),
                      Text('lobby:${lobbyState.lobby.simpleId}'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('1:'),
                              Text(lobbyState.lobby.lovers[0].name),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('2:'),
                              Text(lobbyState.lobby.lovers[1].name),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          obscureText: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9]'),
                            ),
                          ],
                          controller: _lobbyController,
                          decoration: const InputDecoration(
                            hintText: 'Enter lobby id',
                          ),
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
                      //Text(lobbyState.status.description),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('sign out'),
                          ),
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
                      ),
                      TextButton(
                        onPressed: () {
                          LobbyBloc bloc = BlocProvider.of<LobbyBloc>(context);
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
    );
  }
}
