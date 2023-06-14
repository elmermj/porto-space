import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porto_space/screens/conversation/conversation_room_screen.dart';

enum SearchButton {people, occupations, interests }

class SearchController extends GetxController {

  SearchController();

  final TextEditingController searchTextController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;
  final RxBool isSearchActive = false.obs;
  final RxList searchResults = [].obs;
  final selectedButton = SearchButton.people.obs;
  final RxString searchWarning = "".obs;

  final firestoreInstance = FirebaseFirestore.instance;

  void setSelectedButton(SearchButton button) {
    selectedButton.value = button;
    search(searchTextController.text);
  }

  Future<void> search(String keyword) async {
    searchResults.clear();
    
    if (keyword.isNotEmpty) {
      final query = firestoreInstance.collection('users');
      searchWarning.value=keyword;

      switch (selectedButton.value) {
        
        case SearchButton.people:

          final result = await query
              .where('name', isGreaterThanOrEqualTo: keyword)
              .where('name', isLessThan: '${keyword}z')
              .limit(5)
              .get();
          searchResults.assignAll(result.docs);

          if(kDebugMode){
            debugPrint(result.toString());
            if(result.docs.isEmpty){
              debugPrint(searchWarning.value);
            }
          }
          
          break;


        case SearchButton.occupations:
          final result = await query
              .where('occupation', isGreaterThanOrEqualTo: keyword)
              .where('occupation', isLessThan: '${keyword}z')
              .limit(5)
              .get();
          searchResults.assignAll(result.docs);
          if(result.docs.isEmpty){
            searchWarning.value=keyword;
            debugPrint(searchWarning.value);
          }
          break;


        case SearchButton.interests:
          debugPrint("switched to interest search");
          var converted = keyword
              .replaceAll(RegExp(' +'), ' ')
              .split(' ')
              .map((str)  => str[0].toUpperCase()+str.substring(1)).join(' ');

          final result = await query
              .where('interest', arrayContains: keyword)
              // .where('interest', isGreaterThanOrEqualTo: converted)
              // .where('interest', isLessThan: converted + 'z')
              .limit(5)
              .get();

          searchResults.assignAll(result.docs);

          if(result.docs.isEmpty){
            searchWarning.value=converted;
            debugPrint(searchWarning.value);
          }

          break;


        default:
          break;

          
      }
    }
  }

  openConversation({
    String? userId,
    List<String?>? othersId,
    List<String?>? othersName,
    String? convoId
  }) async {
      
    final newChatRef = FirebaseFirestore.instance.collection('chats').doc();
    String? otherId = othersId![0];
    String? otherName = othersName![0];
    

    final querySnapshot = await FirebaseFirestore.instance
      .collection('chats')
      .where('p2p', whereIn: [
        [userId, otherId],
        [otherId, userId]
      ])
      .get();

    final List<String> listDocIds = querySnapshot.docs.map((doc) => doc.id).toList();
    
    var val = DateTime.now().difference(DateTime.utc(2022, 01, 01)).inSeconds;

    if(listDocIds.isEmpty){

      await newChatRef.set({
        'p2p': [userId, otherId],
        'val': val
      });

      debugPrint('CHAT ROOM DOES NOT EXIST YET');

      final query2 = await FirebaseFirestore.instance
        .collection('chats')
        .where('p2p', whereIn: [
          [userId, otherId],
          [otherId, userId]
        ])
        .get();

      final List<String> listDocIds2 = query2.docs.map((doc) => doc.id).toList();
      debugPrint(listDocIds2.toString());
      final chatRoomId = listDocIds2.first;

      await FirebaseFirestore.instance.collection('users').doc(user.uid)
            .update({'on-conv': FieldValue.arrayUnion([chatRoomId]),
            'administrators': {
              otherId: true,
            },
      });

      await FirebaseFirestore.instance.collection('users').doc(otherId)
            .update({'on-conv': FieldValue.arrayUnion([chatRoomId]),
            'administrators': {
              otherId: true,
            },
      });

      Get.to(() => ConversationRoomScreen(
        otherName: otherName,
        otherId: otherId,
        roomId: chatRoomId
      ), arguments: [othersName, othersId, chatRoomId]);

    }
    else{

      final chatRoomId = listDocIds.first;
      debugPrint('CHAT ROOM EXISTS');

      Get.to(()=>
        ConversationRoomScreen(
          otherName: othersName,
          otherId: othersId,
          roomId: chatRoomId
        ), arguments: [othersName, othersId]);
      
      
      update();

      debugPrint('User ID: $userId');
      debugPrint('Other ID: $othersId');

    }
  }
}