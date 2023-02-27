import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunrise/application/screens/screen_relationship.dart';
import 'package:sunrise/application/styles.dart';
import 'package:sunrise/domain/bloc_auth.dart';
import 'package:sunrise/domain/bloc_lobby.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrise/main.dart';
import 'package:video_player/video_player.dart';

class ScreenLobby extends StatefulWidget {
  const ScreenLobby({Key? key}) : super(key: key);
  @override
  State<ScreenLobby> createState() => _ScreenLobbyState();
}

class _ScreenLobbyState extends State<ScreenLobby>
    with TickerProviderStateMixin {
  late final LobbyBloc lobbyBLoc;
  final _lobbyController = TextEditingController();
  late VideoPlayerController _videoPController;

  @override
  void initState() {
    lobbyBLoc = LobbyBloc();
    _videoPController = VideoPlayerController.asset('assets/sunrise.mp4')
      ..initialize().then((_) {
        _videoPController.setLooping(true);
        _videoPController.play();
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    lobbyBLoc.close();
    _videoPController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LobbyBloc>(
      create: (context) => lobbyBLoc,
      child: SafeArea(
        child: Scaffold(
          body: BlocConsumer<LobbyBloc, LobbyState>(
            bloc: lobbyBLoc
              ..add(
                LobbyEventLoad(
                  lover: context.read<AuthBloc>().state.lover,
                  lobbyId: context.read<AuthBloc>().state.lover.lobbyId,
                ),
              ),
            listener: (context, state) {
              if (state.status == LobbyStatus.standBy) {
                lobbyBLoc.add(LobbyEventWatch(lobby: state.lobby));
              }
              if (state.status == LobbyStatus.initial ||
                  state.status == LobbyStatus.sucessNoReady) {}
            },
            builder: (context, lobbyState) {
              return SafeArea(
                child: Stack(
                  children: [
                    VideoPlayer(_videoPController),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogout());
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogout());
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ),
                            );
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<LobbyBloc>.value(
                                  value: context.read<LobbyBloc>(),
                                  child: const RelationshipScreen(),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Text(
                                  'Seguinte',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    lobbyState.lobby.simpleId,
                                    style: kTextLoverLobbyStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
                                              ),
                                            ),
                                          ),
                                          Text(
                                            context
                                                .read<LobbyBloc>()
                                                .state
                                                .lobby
                                                .lovers[0]
                                                .name,
                                            style: kTextLoverLobbyStyle,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
                                              ),
                                            ),
                                          ),
                                          Text(
                                            context
                                                .read<LobbyBloc>()
                                                .state
                                                .lobby
                                                .lovers[1]
                                                .name,
                                            style: kTextLoverLobbyStyle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: FilledButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        context.read<LobbyBloc>().add(
                                              LobbyEventLeave(
                                                lobbyId: _lobbyController.text,
                                                lover: context
                                                    .read<AuthBloc>()
                                                    .state
                                                    .lover,
                                              ),
                                            );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: const [
                                            Text(
                                              'sair',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Icon(
                                              Icons.exit_to_app,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          title: const Text(
                                            'Entrar em outra sala',
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            child: TextField(
                                              onChanged: (value) {
                                                _lobbyController.value =
                                                    TextEditingValue(
                                                  text: value.toUpperCase(),
                                                  selection: _lobbyController
                                                      .selection,
                                                );
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    width: 4,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              cursorColor: Colors.black,
                                              textAlign: TextAlign.center,
                                              style: kTextFormFieldLobbyStyle,
                                              maxLength: 5,
                                              maxLengthEnforcement:
                                                  MaxLengthEnforcement.enforced,
                                              obscureText: false,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp(r'[a-zA-Z0-9]'),
                                                ),
                                              ],
                                              controller: _lobbyController,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    FilledButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_lobbyController.text.length != 5) {
                                          return;
                                        }
                                        context.read<LobbyBloc>().add(
                                              LobbyEventJoin(
                                                lobbyId: _lobbyController.text,
                                                lover: context
                                                    .read<AuthBloc>()
                                                    .state
                                                    .lover,
                                              ),
                                            );
                                      },
                                      child: const Text(
                                        'join',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
