class ChatMessageEntity {
  final String message;
  final String sentById;
  final String sentByName;
  final DateTime dateTime;

  const ChatMessageEntity(
    this.message,
    this.sentById,
    this.sentByName,
    this.dateTime,
  );

  ChatMessageEntity.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        sentById = json['sentById'],
        sentByName = json['sentByName'],
        dateTime = DateTime.parse(json['dateTime']);

  Map<String, dynamic> toJson() => {
        'message': message,
        'sentById': sentById,
        'sentByName': sentByName,
        'dateTime': DateTime.now().toIso8601String(),
      };
}
