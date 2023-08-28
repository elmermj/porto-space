import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:porto_space/models/convocreds.dart';
import 'package:porto_space/models/message.dart';

class ConversationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  RxList<Map<String, dynamic>> messages = RxList<Map<String, dynamic>>([]);
  final textEditChat = TextEditingController();
  User? user;
  RxList otherIds = [].obs;
  RxList otherNames = [].obs;
  RxList<ConvoCreds> convoCreds = <ConvoCreds>[].obs;
  RxBool isRoom = false.obs;
  RxBool isLoading = false.obs;
  var chat = ''.obs;

  var tweenEndValue = 0.0.obs;
  var scaleValue = 1.0.obs;
  var scaleRValue = 0.0.obs;
  var slideValue = 0.2.obs;

  tweenAnimate() {
    tweenEndValue.value == 0.1
        ? tweenEndValue.value = 0
        : tweenEndValue.value = 0.1;
    scaleValue.value == 0.8 ? scaleValue.value = 1 : scaleValue.value = 0.8;
    scaleRValue.value == 0.2
        ? scaleRValue.value = 0
        : scaleRValue.value = 0.2;
    slideValue.value == 0.0 ? slideValue.value = 0.2 : slideValue.value = 0.0;
    update();
  }

  void updateChatValue(String text) {
    chat.value = text;
  }

  getOtherUserIdentity({
    required List fromNames,
    required List fromId,
  }) async {
    isLoading.value = true;
    update();
    for (int i = 0; i < fromNames.length; i++) {
      ConvoCreds convoCred = ConvoCreds(
        senderId: fromId[i],
        senderName: fromNames[i],
      );
      debugPrint("${convoCred.senderId} ${convoCred.senderName} ");
      convoCreds.add(convoCred);
    }
    ConvoCreds userCred = ConvoCreds(senderId: user!.uid, senderName: 'You');
    convoCreds.add(userCred);
    isLoading.value = false;
    update();
    return convoCreds;
  }

  getName({String? senderId}) {
    String? senderName;
    for (ConvoCreds convoCred in convoCreds) {
      if (convoCred.senderId == senderId) {
        senderName = convoCred.senderName;
        break;
      }
    }
    return senderName;
  }

  final _chatCache = <String, List<Message>>{};

  Stream<List<Message>> cachedMessagesStream(String chatId) async* {
    if (_chatCache.containsKey(chatId)) {
      yield _chatCache[chatId]!;
    } else {
      final messages = await loadMessagesFromFirestore(chatId);
      _chatCache[chatId] = messages;
      yield messages;
    }
  }

  Future<List<Message>> loadMessagesFromFirestore(String chatId) async {
    final docRef =
        _firestore.collection('chats').doc(chatId).collection('mes');
    final snapshot = await docRef.orderBy('time', descending: true).get();
    final messagesData = snapshot.docs.map((doc) => doc.data()).toList();
    if (messagesData.isEmpty) {
      return messagesData
          .map((messageData) {
            return Message(
              senderId: messageData['sid'],
              messageContent: messageData['ctn'],
              time: (messageData['time'] as Timestamp).toDate(),
            );
          })
          .toList()
          .cast<Message>();
    }
    return <Message>[];
  }

  Stream<List<Message>> messagesStream(String chatId) {
    return cachedMessagesStream(chatId).map((messages) {
      messages.sort((a, b) => b.time.compareTo(a.time));
      return messages;
    }).asBroadcastStream();
  }

  Future<void> addMessage({
    required String chatId,
    required String senderId,
    required String messageContent,
    required DateTime timestamp
  }) async {
    if (messageContent == '' || messageContent.removeAllWhitespace == '') {
      return;
    }

    var time = DateTime.now().difference(DateTime.utc(2022, 01, 01)).inSeconds;
    final docRef =
        _firestore.collection('chats').doc(chatId).collection('mes').doc(time.toString());
    final messageData = {
      'sid': senderId,
      'time': DateTime.now().toUtc(),
      'ctn': messageContent,
      'nm': true,
    };
    final batch = _firestore.batch();
    batch.set(docRef, messageData);
    batch.update(_firestore.collection('chats').doc(chatId), {'val': time});

    await batch.commit();

    textEditChat.clear();
    _chatCache[chatId] ??= <Message>[];
    _chatCache[chatId]!.add(
      Message(
        senderId: senderId,
        messageContent: messageContent,
        time: DateTime.now(),
      ),
    );

    final membersSnapshot = await _firestore.collection('chats').doc(chatId).get();
    final membersData = membersSnapshot.data();
    final members = membersData!['members'] as List<dynamic>;

    for (String memberId in members) {
      if (memberId != senderId) {
        await sendNotificationToMember(memberId, chatId);
      }
    }

    FocusScope.of(Get.context!).unfocus();
    update();
  }

  Future<void> sendNotificationToMember(String memberId, String chatId) async {
    final userSnapshot = await _firestore.collection('users').doc(memberId).get();
    final userData = userSnapshot.data();
    final deviceToken = userData!['deviceToken'] as String?;

    if (deviceToken != null) {
      final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      const serverKey = 'AIzaSyCBG-rp2_-Qgyq0fNahPsSL-rPYb2gjZOA';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      };

      final notification = {
        'title': 'New Message',
        'body': 'You have a new message in the group chat.',
      };

      final data = {
        'chatId': chatId,
      };

      final body = {
        'notification': notification,
        'data': data,
        'to': deviceToken,
      };

      final response = await post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // notification sent successfully
        debugPrint('Notification sent to device: $deviceToken');
      } else {
        // error sending notification
        debugPrint('Failed to send notification to device: $deviceToken');
      }
    }
  }

  @override
  Future<void> onInit() async {
    FirebaseMessaging.instance.getToken().then((token) => print(token));
    FirebaseMessaging.onMessage.listen((message) {
      addMessage(
        chatId: message.data['chatId'],
        senderId: message.data['sid'],
        messageContent: message.data['ctn'],
        timestamp: message.data['time']
      );
    });

    user = _firebaseAuth.currentUser;
    final List args = Get.arguments;
    await getOtherUserIdentity(fromNames: args[0], fromId: args[1]);
    update();
    messages.value = [];
    super.onInit();
  }
}

class ConversationBinding extends Bindings{
  ConversationBinding();
  @override
  void dependencies() {
    Get.lazyPut<ConversationController>(() => ConversationController());
  }

}