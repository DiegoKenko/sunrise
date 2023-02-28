import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunrise/application/screens/screen_relationship.dart';
import 'package:sunrise/application/styles.dart';
import 'package:sunrise/domain/bloc_auth.dart';
import 'package:sunrise/domain/bloc_lobby.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrise/main.dart';

class ScreenLobby extends StatefulWidget {
  const ScreenLobby({Key? key}) : super(key: key);
  @override
  State<ScreenLobby> createState() => _ScreenLobbyState();
}

class _ScreenLobbyState extends State<ScreenLobby>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LobbyBloc>(
      create: (context) => LobbyBloc()
        ..add(
          LobbyEventLoad(
            lover: context.read<AuthBloc>().state.lover,
            lobbyId: context.read<AuthBloc>().state.lover.lobbyId,
          ),
        ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocConsumer<LobbyBloc, LobbyState>(
            listener: (context, state) {
              if (state.status == LobbyStatus.standBy) {
                context
                    .read<LobbyBloc>()
                    .add(LobbyEventWatch(lobby: state.lobby));
              }
              if (state.status == LobbyStatus.initial ||
                  state.status == LobbyStatus.sucessNoReady) {}
            },
            builder: (context, lobbyState) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.2, 0.7, 1.0],
                    colors: [
                      Color(0xFF046fb5),
                      Color(0xFF04b0e0),
                      Color(0xFFcdf6f6),
                      Color(0xFFf98a5a),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  color: Colors.transparent,
                                ),
                                margin: const EdgeInsets.only(top: 20),
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      lobbyState.lobby.simpleId,
                                      style: kTextLobbyStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FilledButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.white,
                                            ),
                                            side: MaterialStateProperty.all(
                                              const BorderSide(
                                                color: Colors.red,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            context.read<LobbyBloc>().add(
                                                  LobbyEventLeave(
                                                    lover: context
                                                        .read<AuthBloc>()
                                                        .state
                                                        .lover,
                                                  ),
                                                );
                                          },
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.exit_to_app,
                                                color: Colors.red,
                                              ),
                                              Text('Sair da sala',
                                                  style: kTextLeaveLobbyStyle),
                                            ],
                                          ),
                                        ),
                                        FilledButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.white,
                                            ),
                                            side: MaterialStateProperty.all(
                                              const BorderSide(
                                                color: Colors.red,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            context
                                                .read<AuthBloc>()
                                                .add(const AuthEventLogout());
                                            context
                                                .read<AuthBloc>()
                                                .add(const AuthEventLogout());
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Home(),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.logout,
                                                color: Colors.red,
                                              ),
                                              Text('Logout',
                                                  style: kTextLeaveLobbyStyle),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                              const LoversLobbyAtual(),
                              Expanded(child: Container()),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FilledButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Colors.orange,
                                        ),
                                        side: MaterialStateProperty.all(
                                          const BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (lobbyState.status ==
                                            LobbyStatus.sucessReady) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider<LobbyBloc>.value(
                                                value:
                                                    context.read<LobbyBloc>(),
                                                child:
                                                    const RelationshipScreen(),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: const [
                                            Text(
                                              'Próximo',
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
                                ],
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: LoginOutraSala(),
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

class LoversLobbyAtual extends StatefulWidget {
  const LoversLobbyAtual({
    super.key,
  });

  @override
  State<LoversLobbyAtual> createState() => _LoversLobbyAtualState();
}

class _LoversLobbyAtualState extends State<LoversLobbyAtual> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<LobbyBloc, LobbyState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 30,
                          child: Image.asset('assets/avatar.png'),
                        ),
                      ),
                      Text(
                        state.lobby.lovers[0].name,
                        style: kTextLoverLobbyStyle,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 30,
                          child: Image.asset('assets/avatar.png'),
                        ),
                      ),
                      Text(
                        state.lobby.lovers[1].name.isEmpty
                            ? 'aguardando...'
                            : state.lobby.lovers[1].name,
                        style: kTextLoverLobbyStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class LoginOutraSala extends StatefulWidget {
  const LoginOutraSala({super.key});

  @override
  State<LoginOutraSala> createState() => _LoginOutraSalaState();
}

class _LoginOutraSalaState extends State<LoginOutraSala> {
  final _lobbyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
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
                          _lobbyController.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _lobbyController.selection,
                          );
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        cursorColor: Colors.black,
                        textAlign: TextAlign.center,
                        style: kTextFormFieldLobbyStyle,
                        maxLength: 5,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        obscureText: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
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
                  backgroundColor: MaterialStateProperty.all(
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
                          lover: context.read<AuthBloc>().state.lover,
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
        ),
      ],
    );
  }
}
