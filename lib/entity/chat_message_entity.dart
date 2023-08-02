class ChatMessageEntity {
  final String message;
  final String sentBy;
  final DateTime dateTime;

  const ChatMessageEntity(
    this.message,
    this.sentBy,
    this.dateTime,
  );

  ChatMessageEntity.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        sentBy = json['sentBy'],
        dateTime = DateTime.parse(json['dateTime']);

  Map<String, dynamic> toJson() => {
        'message': message,
        'sentBy': sentBy,
        'dateTime': DateTime.now().toIso8601String(),
      };
}
