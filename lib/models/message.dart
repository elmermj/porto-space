import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final DateTime time;
  final String messageContent;

  Message({
    required this.senderId,
    required this.time,
    required this.messageContent,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['sid'],
      time: (map['time'] as Timestamp).toDate(),
      messageContent: map['mes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sid': senderId,
      'time': time,
      'mes': messageContent,
    };
  }
}