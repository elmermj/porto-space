import 'package:hive/hive.dart';

class ConvoPreview extends HiveObject {
  final String convoId;
  final List<String> othersId;
  final List<String> othersName;
  String senderId;
  String lastMessageId;
  String lastMessage;
  DateTime timeStamp;
  bool newMessage;

  ConvoPreview({
    required this.convoId,
    required this.othersId,
    required this.othersName,
    required this.senderId,
    required this.lastMessageId,
    required this.lastMessage,
    required this.timeStamp,
    required this.newMessage
  });
}
