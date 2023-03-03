import 'package:expandable/expandable.dart';
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
  final _salaAtualController = ExpandableController(initialExpanded: true);
  final _novaSalaController = ExpandableController(initialExpanded: false);
  final _leaveLobbyController = ExpandableController(initialExpanded: false);
  final _lobbyController = TextEditingController();

  @override
  void initState() {
    _salaAtualController.addListener(() {
      if (_novaSalaController.expanded == _salaAtualController.expanded) {
        _novaSalaController.toggle();
      }
    });
    _novaSalaController.addListener(() {
      if (_novaSalaController.expanded == _salaAtualController.expanded) {
        _salaAtualController.toggle();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<LobbyBloc>(
        create: (context) => LobbyBloc()
          ..add(
            LobbyEventLoad(
              lover: context.read<AuthBloc>().state.lover,
              lobbyId: context.read<AuthBloc>().state.lover.lobbyId,
            ),
          ),
        child: Scaffold(
          body: BlocConsumer<LobbyBloc, LobbyState>(
            listener: (context, state) {
              if (state.status == LobbyStatus.sucessNoReady) {
                context.read<LobbyBloc>().add(const LobbyEventWatch());
              }
            },
            builder: (context, lobbyState) {
              return SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Color.fromARGB(255, 81, 81, 97),
                          Color.fromARGB(255, 0, 0, 0),
                        ],
                        radius: 1.4,
                      ),
                    ),
                    child: Column(
                      children: [
                        ExpandablePanel(
                          controller: _salaAtualController,
                          expanded: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            decoration: kLobbyLeftBoxDecoration,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    context
                                                        .read<LobbyBloc>()
                                                        .state
                                                        .lobby
                                                        .simpleId,
                                                    style: kTextLobbyStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            decoration:
                                                kLobbyRightBoxDecoration,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _salaAtualController.toggle();
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.search_rounded,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const LoversLobbyAtual(),
                                Expandable(
                                  controller: _leaveLobbyController,
                                  collapsed: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _leaveLobbyController.toggle();
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.exit_to_app,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  expanded: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _leaveLobbyController.toggle();
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.chevron_left,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Column(
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
                                                Text(
                                                  'Sair da sala',
                                                  style: kTextLeaveLobbyStyle,
                                                ),
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
                                                Text(
                                                  'Logout',
                                                  style: kTextLeaveLobbyStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(child: Container())
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: kLobbyRightBoxDecoration,
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (context
                                                .read<LobbyBloc>()
                                                .state
                                                .status ==
                                            LobbyStatus.sucessReady) {
                                          var lobbyBloc =
                                              context.read<LobbyBloc>();
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider<LobbyBloc>.value(
                                                value: lobbyBloc,
                                                child:
                                                    const RelationshipScreen(),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                          ),
                          collapsed: Container(
                            color: Colors.transparent,
                          ),
                        ),
                        ExpandablePanel(
                          controller: _novaSalaController,
                          expanded: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _novaSalaController.toggle();
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.chevron_left,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      onChanged: (value) {
                                        _lobbyController.value =
                                            TextEditingValue(
                                          text: value.toUpperCase(),
                                          selection: _lobbyController.selection,
                                        );
                                      },
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 4,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 4,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      cursorColor: Colors.white,
                                      textAlign: TextAlign.center,
                                      style: kTextFormFieldLobbyStyle,
                                      maxLength: 5,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      obscureText: false,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z0-9]'),
                                        ),
                                      ],
                                      controller: _lobbyController,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    width: double.infinity,
                                    child: FilledButton(
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
                                        'entrar',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          collapsed: Container(
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 50,
                        child: Image.asset('assets/avatar.png'),
                      ),
                    ),
                    Text(
                      state.lobby.lovers[0].name,
                      style: kTextLoverLobbyStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 50,
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
              ),
            ],
          );
        },
      ),
    );
  }
}
