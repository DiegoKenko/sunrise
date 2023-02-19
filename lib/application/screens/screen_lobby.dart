import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunrise/application/screens/screen_relationship.dart';
import 'package:sunrise/domain/bloc_auth.dart';
import 'package:sunrise/domain/bloc_lobby.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrise/main.dart';

class ScreenLobby extends StatefulWidget {
  const ScreenLobby({Key? key}) : super(key: key);
  @override
  State<ScreenLobby> createState() => _ScreenLobbyState();
}

class _ScreenLobbyState extends State<ScreenLobby> {
  final TextEditingController _lobbyController = TextEditingController();
  late final LobbyBloc lobbyBLoc;

  @override
  void initState() {
    lobbyBLoc = LobbyBloc();
    super.initState();
  }

  @override
  void dispose() {
    lobbyBLoc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<LobbyBloc, LobbyState>(
          bloc: lobbyBLoc
            ..add(
              LobbyEventLoad(
                lover: context.read<AuthBloc>().state.lover,
                lobbyId: context.read<AuthBloc>().state.lover.lobbyId,
              ),
            ),
          listener: (context, state) {
            if (state.status == LobbyStatus.waiting) {
              lobbyBLoc.add(LobbyEventWatch(lobby: state.lobby));
            }
            if (state.status == LobbyStatus.sucessReady) {
              /*     Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => BlocProvider<LobbyBloc>.value(
                    value: lobbyBLoc,
                    child: const RelationshipScreen(),
                  ),
                ),
              ); */
            }
          },
          builder: (context, lobbyState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'logged as :${context.read<AuthBloc>().state.lover.name}',
                ),
                Text('lobby:${lobbyState.lobby.simpleId}'),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('1:'),
                        Text(lobbyState.lobby.lovers[0].name),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('2:'),
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
                    if (_lobbyController.text.length != 5) {
                      return;
                    }
                    lobbyBLoc.add(
                      LobbyEventJoin(
                        lobbyId: _lobbyController.text,
                        lover: context.read<AuthBloc>().state.lover,
                      ),
                    );
                  },
                  child: const Text('join'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthEventLogout());
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ),
                        );
                      },
                      child: const Text('sign out'),
                    ),
                    TextButton(
                      onPressed: () {
                        lobbyBLoc.add(
                          LobbyEventLeave(
                            lobbyId: _lobbyController.text,
                            lover: context.read<AuthBloc>().state.lover,
                          ),
                        );
                      },
                      child: const Text('leave'),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider<LobbyBloc>.value(
                          value: lobbyBLoc,
                          child: const RelationshipScreen(),
                        ),
                      ),
                    );
                  },
                  child: const Text('go to relationship'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
