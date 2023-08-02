import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunrise/constants/styles.dart';

class LobbyJoinWidget extends StatefulWidget {
  const LobbyJoinWidget({super.key, required this.onPop});
  final Function() onPop;

  @override
  State<LobbyJoinWidget> createState() => _LobbyJoinWidgetState();
}

class _LobbyJoinWidgetState extends State<LobbyJoinWidget> {
  final _lobbyTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            decoration: kLobbyLeftBoxDecoration.copyWith(
              color: kPrimaryColor,
            ),
            width: MediaQuery.of(context).size.width * 0.3,
            child: IconButton(
              onPressed: widget.onPop,
              icon: const Icon(
                Icons.chevron_left,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            onChanged: (value) {
              _lobbyTextController.value = TextEditingValue(
                text: value.toUpperCase(),
                selection: _lobbyTextController.selection,
              );
            },
            decoration: InputDecoration(
              enabledBorder: kOutlineInputBorder,
              focusedBorder: kOutlineInputBorder,
              label: const Text(
                'Código da sala',
                style: kTextFormFieldLobbyLabelStyle,
              ),
            ),
            cursorColor: Colors.white,
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
            controller: _lobbyTextController,
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.3,
          child: FilledButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.white,
              ),
            ),
            onPressed: () {
              if (_lobbyTextController.text.length != 5) {
                return;
              }
            },
            child: const Text(
              'ENTRAR',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
