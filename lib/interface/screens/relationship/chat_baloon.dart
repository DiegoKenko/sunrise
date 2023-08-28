import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/entity/chat_message_entity.dart';
import 'package:sunrise/interface/extensions/string_capitalize.dart';

enum EnumPosition {
  left,
  right,
}

class ChatBaloon extends StatelessWidget {
  const ChatBaloon({
    Key? key,
    required this.message,
    required this.position,
  }) : super(key: key);
  final ChatMessageEntity message;
  final EnumPosition position;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: FractionallySizedBox(
        alignment: position == EnumPosition.left
            ? Alignment.centerLeft
            : Alignment.centerRight,
        widthFactor: 0.8,
        child: Container(
          alignment: position == EnumPosition.left
              ? Alignment.topLeft
              : Alignment.topRight,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: position == EnumPosition.left
                ? k2LevelColor.withOpacity(0.8  )
                : kPrimaryColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Align(
                alignment: position == EnumPosition.left
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: Text(
                  DateFormat('dd/MM HH:mm').format(message.dateTime),
                  style: kDateTimeChatTextStyle,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: position == EnumPosition.left
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                child: Column(
                  children: [
                    Text(
                      message.message.capitalize(),
                      softWrap: true,
                      style: kTextChatMessageStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
