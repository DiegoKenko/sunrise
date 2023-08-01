import 'package:flutter/material.dart';
import 'package:sunrise/application/screens/controller/avatar_change_controller.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/model/model_lover.dart';

class AvatarWidget extends StatefulWidget {
  final Lover lover;
  final bool edit;
  const AvatarWidget({
    super.key,
    required this.lover,
    this.edit = false,
  });

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.lover.id.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AvatarWidgetEdit(
                    lover: widget.lover,
                    edit: widget.edit,
                  ),
                  Text(
                    widget.lover.name,
                    style: kTextLoverLobbyStyle,
                  ),
                ],
              )
            : AvatarWidgetEdit(
                lover: widget.lover,
                edit: widget.edit,
              ),
      ),
    );
  }
}

class AvatarWidgetEdit extends StatefulWidget {
  final Lover lover;
  final bool edit;
  const AvatarWidgetEdit({
    super.key,
    required this.lover,
    this.edit = false,
  });

  @override
  State<AvatarWidgetEdit> createState() => _AvatarWidgetEditState();
}

class _AvatarWidgetEditState extends State<AvatarWidgetEdit> {
  final AvatarChangeController avatarChangeController =
      AvatarChangeController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            avatarChangeController.toLeft();
          },
          icon: Icon(
            Icons.chevron_left,
            color: widget.edit ? Colors.white : Colors.transparent,
            size: 25,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: avatarChangeController,
          builder: (context, state, _) {
            return Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: widget.lover.id.isEmpty
                      ? Image.asset('assets/avatar.png')
                      : Image.asset(state),
                ),
              ),
            );
          },
        ),
        IconButton(
          onPressed: () {
            avatarChangeController.toRight();
          },
          icon: Icon(
            Icons.chevron_right,
            color: widget.edit ? Colors.white : Colors.transparent,
            size: 25,
          ),
        ),
      ],
    );
  }
}
