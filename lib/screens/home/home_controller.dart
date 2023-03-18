import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/constants.dart';
import 'package:porto_space/models/convopreview.dart';
import 'package:porto_space/models/project_item.dart';
import 'package:porto_space/screens/conversation/conversation_room_screen.dart';
import 'package:porto_space/screens/projects/projects_index.dart';
import 'package:rive/rive.dart';

enum ProjectStages{initial, inProgress, onPause, completed, cancelled}

extension ProjectStageNames on ProjectStages {
  String get name => this.toString().split('.').last;
}

class HomeController extends GetxController{

  HomeController();

  late final List<String> tabTitles;
  late final PageController pageController;
  late final List<BottomNavigationBarItem> bottomTabs;
  final selectedProjectStage = ProjectStages.initial.obs;
  RxInt page = 0.obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser!;

  String? name, dob, city, occupation, currentCompany, profileDesc;
  String? eduLevel, eduInstitute, fieldOfStudy, eduYearStart, eduYearEnd;
  final color = Rx<Color>(const Color.fromARGB(255, 88, 233, 255));
  RxList education = [].obs;
  RxList interests = [].obs;
  RxList newInterests = [].obs;
  RxList projectList = [].obs;
  List onConv = [];
  RxList convoList = [].obs;

  final scrollController = ScrollController();
  final textEditProfileDesc = TextEditingController();
  final textEditInterest = TextEditingController();

  RxBool isEdit = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingSnackBar = false.obs;
  RxBool ongoing = false.obs;
  RxBool isUnemployed = false.obs;
  RxBool isAuthor = true.obs;


  var tweenEndValue = 0.0.obs;
  var scaleValue = 1.0.obs;
  var scaleRValue = 0.0.obs;
  var slideValue = 0.2.obs;
  RxList<Color> colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow].obs;

  addData(){
    colors.addAll([Colors.red, Colors.green, Colors.blue, Colors.yellow].obs);
    update();
  }

  tweenAnimate(){
    tweenEndValue.value == 0.05? tweenEndValue.value= 0:tweenEndValue.value=0.05; 
    scaleValue.value == 0.95? scaleValue.value=1: scaleValue.value=0.95;
    scaleRValue.value == 0.35? scaleRValue.value=0: scaleRValue.value=0.35;
    slideValue.value == 0.0? slideValue.value=0.2: slideValue.value=0.0;
    update();
  }

  tweenAnimateRight(){
    tweenEndValue.value ==-0.75? tweenEndValue.value= 0:tweenEndValue.value=-0.75;
    scaleValue.value == 0.8? scaleValue.value=1: scaleValue.value=0.8;
  }
  
  toggleOngoing({required bool ongoing}){
    if (ongoing==true){
      eduYearEnd = 'Present';
    }else{
      eduYearEnd = '';
    }
    update();
  }

  RxBool isProfileDescFieldActive = false.obs;

  void activateTextField() {
    isProfileDescFieldActive.value = true;
    update();
  }
  void deactivateTextField() {
    isProfileDescFieldActive.value = false;
    update();
  }



  void saveProfileDesc() async {
    try {
      isLoading.value=true;
      update();
      await FirebaseFirestore.instance
          .collection('users').doc(user.uid).set({'profileDesc': textEditProfileDesc.text},
          SetOptions(merge: true));
      debugPrint('Data saved successfully');
      deactivateTextField();
      loadProfile(partial: true);
      isLoading.value=false;
      update();
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  loadProfile({required bool partial}) async {
    DocumentSnapshot documentSnapshot = 
    await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    name = data['name'];
    dob = data['dob'];
    city = data['city'];
    profileDesc = data['profileDesc'];
    occupation = data['occupation'];
    currentCompany = data['currentCompany'];

    if(data['projectList']!=null) projectList.value = data['projectList'];
    print(projectList);

    if(data['interest']!=null) interests.value = data['interest'];
    print(interests);
    

    if(profileDesc==null||data['profileDesc']==null){
      profileDesc = "You haven't described yourself";
      textEditProfileDesc.text = profileDesc!;
      update();
    }


    if(occupation == null || occupation =='Unemployed') {
      isUnemployed.value = true;
      update();
    }
    if(occupation !='Unemployed') {
      isUnemployed.value = false;
      update();
    }

    if(!partial){
      education = await fetchEduHistory();
    };

    if (kDebugMode) {
      print("name: $name. dob: $dob. city: $city. occupation: $occupation. currentCompany: $currentCompany ");
      print(education);
    }
    textEditProfileDesc.text = profileDesc!;
    update();
  }

  addInterest({String? interest}){
    newInterests.add(
      interest!.replaceAll(
          RegExp(' +'), ' '
        ).split(' ').map((str) 
        => str[0].toUpperCase()+str.substring(1)).join(' ')
    );
    update();
    textEditInterest.clear();
    FocusScope.of(Get.context!).unfocus();
    print("Added interest : $interests");
    print("Added New : $newInterests");
  }

  removeInterest({
    required int index
  }){
    newInterests.removeAt(index);
    update();
  }

  submitInterest() async {
    showSnackBar(title: 'Submitting Changes', message: 'Please Wait');
    var userDocRef = firestore.collection('users').doc(user.uid);
    var interestsColl = firestore.collection('interest');
    var count=0;

    if(user==null)print("NOT AUTH");

    if(interests.length==newInterests.length){
      for(int i=0;i<interests.length;i++){
        if(interests[i]!=newInterests[i])count++;
      }
      if (kDebugMode) {
        print("Difference count ::: $count");
      }
    }

    if(count==0){
      final batch = firestore.batch();
      batch.update(userDocRef, {
        'interest': newInterests
      });
      // for(var interest in newInterests){
      //   print("INTEREST : $interest");
      //   batch.set(interestsColl.doc(interest).collection('mem').doc(user.uid), {
      //     'ct':Timestamp.now()
      //   });
      //   print(batch.toString());
      // }
      await batch.commit();
    }

    interests=RxList.from(newInterests);
    Get.back();
  }

  createEduHistoryItem(int hashCode) async {
    try{
      var newQuery = {
        "hashCode":hashCode,
        "eduLevel":eduLevel,
        "eduInstitute":eduInstitute,
        "fieldOfStudy":fieldOfStudy,
        "eduYearStart":eduYearStart,
        "eduYearEnd":eduYearEnd,
      };

      await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('educationHistory')
                      .doc().set(newQuery);
      loadProfile(partial: false);
      update();

    }on Exception{
      if (kDebugMode) {
        print(Exception());
      }
    }
  }

  fetchEduHistory() async {
    education.clear();
    try {
      var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('educationHistory')
        .orderBy("eduYearEnd", descending: true)
        .get();
      
      for (var doc in snapshot.docs) { 
        education.add(doc.data());
      }
      update();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return education;
  }

  
  updateEduHistoryItem(int hashCode) async {
    try {
      print(hashCode);
      var newQuery = {
        "eduLevel":eduLevel,
        "eduInstitute":eduInstitute,
        "fieldOfStudy":fieldOfStudy,
        "eduYearStart":eduYearStart,
        "eduYearEnd":eduYearEnd,
      };

      final eduHistoryCollection = FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('educationHistory');
                      
      final querySnapshot = await eduHistoryCollection.where('hashCode', isEqualTo: hashCode).get();
      final batch = FirebaseFirestore.instance.batch();
      for (var element in querySnapshot.docs) {
        batch.update(element.reference, newQuery);
        if (kDebugMode) {
          print('querySnapshot: ${querySnapshot.toString()}');
          print('${element.reference} $newQuery');
        }
      }
      await batch.commit();
      loadProfile(partial: false);
      update();

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  deleteEduHistoryItem(int hashCode) async {
    try {
      final eduHistoryCollection = FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('educationHistory');
      final querySnapshot = await eduHistoryCollection.where('hashCode', isEqualTo: hashCode).get();
      final batch = FirebaseFirestore.instance.batch();
      for (var element in querySnapshot.docs) {
        batch.delete(element.reference);
      }
      
      await batch.commit();
      loadProfile(partial: false);
      update();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  // PROJECTS SUB SCREEN
  ///
  ///
  ///
  // PROJECTS SUB SCREEN
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////

  final projectKey = GlobalKey<FormState>();
  
  String projectName='',
           projectRole='Author', 
           projectAuthor='', 
           projectDescription='', 
           projectStatus ='Initial',
           memberCount = '1';
  RxList projectMemberList = [].obs;
  String projectEmptyWarning = 'No Project Has Been Retrieved';

  RxList projectKeywords = [].obs;
  RxList<ProjectItem> projectListItems = <ProjectItem>[].obs;

  final addMemberEditText = TextEditingController(); 

  toggleAuthor({required bool isAuthor}){
    isAuthor? projectRole = 'Author':projectRole = 'Contributor';
    update();
    print(projectRole);
    update();
  }

  addProjectKeyword({
    String? keywords
  }){
    if (addMemberEditText.text.removeAllWhitespace!='') {

      projectKeywords.add(
        keywords!.replaceAll(
          RegExp(' +'), ' '
        ).split(' ').map((str) 
        => str[0].toUpperCase()+str.substring(1).toLowerCase()).join(' ')
      );
      addMemberEditText.clear();
      addMemberEditText.clearComposing();
      update();
    }
  }

  removeProjectKeyword({
    required int index,
  }){
    projectKeywords.removeAt(index);
    update();
  }
  
  setProjectButton(ProjectStages stage) {
    selectedProjectStage.value = stage;
    projectStageButton();
  }

  projectStageButton(){

    switch(selectedProjectStage.value){
      case ProjectStages.initial:
        projectStatus = 'Initial';
        color.value = const Color.fromARGB(255, 88, 233, 255);
        update();
        print(projectStatus);
        break;
      case ProjectStages.inProgress:
        projectStatus = 'In Progress';
        color.value = const Color.fromARGB(255, 88, 191, 255);
        update();
        print(projectStatus);
        break;
      case ProjectStages.onPause:
        projectStatus = 'On Pause';
        color.value = Color.fromARGB(255, 232, 216, 39);
        update();
        print(projectStatus);
        break;
      case ProjectStages.completed:
        projectStatus = 'Completed';
        color.value = const Color.fromARGB(255, 102, 255, 88);
        update();
        print(projectStatus);
        break;
      case ProjectStages.cancelled:
        projectStatus = 'Cancelled';
        color.value = const Color.fromARGB(255, 255, 88, 88);
        update();
        print(projectStatus);
        break;
    }
  }

  clearProjectField(){
    selectedProjectStage.value = ProjectStages.initial;
    projectKeywords.clear();
    update();
  }

  createProjectItem() async {
    if(projectAuthor=='') projectAuthor = name!;
    projectKey.currentState!.save();
    try{
      showSnackBar(title: 'Creating Project', message: 'Swipe to dismiss');
      var projectId = user.uid+DateTime.now().difference(DateTime.utc(2022, 01, 01)).inSeconds.toString();
      final batch = firestore.batch();
      var projectInfoQuery = {
        "projectName":projectName,
        "projectDesc":projectDescription,
        "projectAuthor":projectAuthor,
        "projectStatus":projectStatus,
        "keywords": projectKeywords.value,
        "memberCount": memberCount,
        "createdBy":name,
        "time":FieldValue.serverTimestamp()
      };

      var memberQuery = {
        "memId":user.uid,
        "memName":name,
        "role":projectRole
      };

      var projInfoDocRef = firestore.collection('projects').doc(projectId);
      var projMemDocRef = projInfoDocRef.collection('members').doc();
      var creatorDocRef = firestore.collection('users').doc(user.uid);

      batch.set(projInfoDocRef, projectInfoQuery);
      batch.update(creatorDocRef, {"projectList":FieldValue.arrayUnion([projectId])});
      batch.set(projMemDocRef, memberQuery);

      await batch.commit();
      update();
      await loadProfile(partial: true);
      await fetchProjectList();
      Get.back();
    }catch (e){
      print(e);
    }
  }

  fetchProjectList() async {

    projectListItems.clear();
    final batch = firestore.batch();
    print("PROJECT LIST ::: $projectList");
    try {
      var projectRefs = projectList
                            .map((projectId) => 
                            firestore.collection('projects')
                            .doc(projectId)).toList();

      var projectsQuery = firestore.collectionGroup('projects')
                                  .where(FieldPath.documentId, whereIn: projectRefs);

      var projectSnapshot = await projectsQuery.get();
      var projects  = projectSnapshot.docs;

      for(var project in projects){

        final projectItemId = project.id;
        final projectItemName = project.data()['projectName'];
        final projectItemDesc = project.data()['projectDesc'];
        final projectItemAuthor = project.data()['projectAuthor'];
        final projectItemStatus = project.data()['projectStatus'];
        final projectItemKeywords = project.data()['keywords'];
        final projectKeywords = List<String>.from(projectItemKeywords.toList());
        final projectItemMembercount = project.data()['memberCount'];
        final itemCreatedTime = project.data()['time'];

        ProjectItem projectItem = ProjectItem(
          projectId: projectItemId,
          projectName: projectItemName,
          projectDescription: projectItemDesc,
          projectAuthor: projectItemAuthor,
          projectStatus: projectItemStatus,
          projectKeywords: projectKeywords,
          memberCount: int.parse(projectItemMembercount),
          timeCreated: itemCreatedTime
        );

        projectListItems.add(projectItem);
        update();

      }

      update();

    } catch (e) {

      if (kDebugMode) {

        print(e);

      }

    }
    return projectListItems;
  }

  openProjectPage({
    required ProjectItem projectData,
    required String projectId
  }){
    Get.to(() =>
      ProjectPageScreen(
          projectData: projectData,
          projectId: projectId,
      ), 
      arguments: [projectData, projectId], 
      transition: Transition.rightToLeft
    );

    update();
    
  }

  
  // updateEduHistoryItem(int hashCode) async {
  //   try {
  //     print(hashCode);
  //     var newQuery = {
  //       "eduLevel":eduLevel,
  //       "eduInstitute":eduInstitute,
  //       "fieldOfStudy":fieldOfStudy,
  //       "eduYearStart":eduYearStart,
  //       "eduYearEnd":eduYearEnd,
  //     };

  //     final eduHistoryCollection = FirebaseFirestore.instance
  //                     .collection('users')
  //                     .doc(user.uid)
  //                     .collection('educationHistory');
                      
  //     final querySnapshot = await eduHistoryCollection.where('hashCode', isEqualTo: hashCode).get();
  //     final batch = FirebaseFirestore.instance.batch();
  //     for (var element in querySnapshot.docs) {
  //       batch.update(element.reference, newQuery);
  //       if (kDebugMode) {
  //         print('querySnapshot: ${querySnapshot.toString()}');
  //         print('${element.reference} $newQuery');
  //       }
  //     }
  //     await batch.commit();
  //     loadProfile(partial: false);
  //     update();

  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }

  // deleteEduHistoryItem(int hashCode) async {
  //   try {
  //     final eduHistoryCollection = FirebaseFirestore.instance
  //                     .collection('users')
  //                     .doc(user.uid)
  //                     .collection('educationHistory');
  //     final querySnapshot = await eduHistoryCollection.where('hashCode', isEqualTo: hashCode).get();
  //     final batch = FirebaseFirestore.instance.batch();
  //     for (var element in querySnapshot.docs) {
  //       batch.delete(element.reference);
  //     }
      
  //     await batch.commit();
  //     loadProfile(partial: false);
  //     update();
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   // }
  // }





  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  // CONVERSATIONS SCREEN
  ///
  ///
  ///
  // CONVERSATIONS SCREEN
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  
  
  void _subscribeToConversations() {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    userRef.snapshots().listen((docSnapshot) async {
      if (!docSnapshot.exists || !docSnapshot.data()!.containsKey('on-conv')) {
        convoList = [].obs;
        update();
        return;
      }

      final List<String> convoIds = List<String>.from(docSnapshot.data()!['on-conv']);
      final List<Future<ConvoPreview>> futures = [];

      for (final convoId in convoIds) {
        final convoRef = FirebaseFirestore.instance.collection('chats').doc(convoId);

        final convoSnapshot = await convoRef.get();
        if (!convoSnapshot.exists) {
          continue;
        }

        futures.add(convoRef.snapshots().first.then((convoSnapshot) async {
          if (!convoSnapshot.exists || !convoSnapshot.data()!.containsKey('val')) {
            return Future.value(null);
          }

          final val = convoSnapshot.data()!['val'];
          final messageRef = convoRef.collection('mes').doc(val.toString());
          final messageSnapshot = await messageRef.get();

          // if (!messageSnapshot.exists) continue;
          final senderId = messageSnapshot.data()!['sid'];
          final newMessage = messageSnapshot.data()!['nm'];
          final lastMessage = messageSnapshot.data()!['ctn'];
          final lastMessageTime = messageSnapshot.data()!['time'].toDate();
          final List<dynamic> participants = convoSnapshot.data()!['p2p'];
          final othersName = <String>[];
          final othersId = <String>[];
          for (final participant in participants) {
            if (participant != user.uid) {
              final participantRef = FirebaseFirestore.instance.collection('users').doc(participant);
              final participantSnapshot = await participantRef.get();
              final name = participantSnapshot.data()!['name'];
              othersName.add(name);
              othersId.add(participant);
            }
          }

          final convoPreview = ConvoPreview(
            convoId: convoId,
            othersId: othersId,
            othersName: othersName,
            senderId: senderId,
            lastMessageId: messageSnapshot.id,
            lastMessage: lastMessage,
            timeStamp: lastMessageTime,
            newMessage: newMessage
          );

          convoRef.snapshots().listen((convoSnapshot) async {
            if (convoSnapshot.exists && convoSnapshot.data()!.containsKey('val')) {
              final val = convoSnapshot.data()!['val'];
              final messageRef = convoRef.collection('mes').doc(val.toString());
              final messageSnapshot = await messageRef.get();
              if (messageSnapshot.exists) {
                convoPreview.lastMessageId = messageSnapshot.id;
                convoList.refresh();
              }
            }
          });

          final messagesRef = convoRef.collection('mes');
          messagesRef.orderBy('time', descending: true).limit(1).snapshots().listen((messagesSnapshot) {
            if (messagesSnapshot.docs.isNotEmpty) {
              final newMessageSnapshot = messagesSnapshot.docs.first;
              final newMessageTime = newMessageSnapshot['time'].toDate();
              convoPreview.senderId = newMessageSnapshot['sid'];
              convoPreview.lastMessage = newMessageSnapshot['ctn'];
              convoPreview.timeStamp = newMessageTime;
              convoPreview.newMessage = newMessageSnapshot['nm'];
            }
            convoList.refresh();
          });

          return convoPreview;
        }));
      }

      Future.wait(futures).then((convoPreviews) {
        convoList.value = convoPreviews.where((preview) => preview != null).toList();
        update();
      });
    });
    if(convoList.isNotEmpty){
      convoList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
    }
  }

  openConversation({
    String? userId,
    List<String?>? othersId,
    List<String?>? othersName,
    String? convoId,
    String? lastMessageId
  }) async {
    var lastMesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(convoId)
        .collection('mes')
        .doc(lastMessageId);
    var lastMesDoc = await lastMesRef.get(const GetOptions(source: Source.server));
    if (lastMesDoc.exists && lastMesDoc['sid'] != userId) {

      showSnackBar(title: 'Loading. Please wait...', message: 'Swipe to dismiss');
      
      await lastMesRef.update({'nm': false});
      Get.back();
      // debugPrint("BATCH COMMITTED");
    }

    // debugPrint('CHAT ROOM EXISTS');
    Get.to(() =>
        ConversationRoomScreen(
            otherName: othersName,
            otherId: othersId,
            roomId: convoId
        ), arguments: [othersName, othersId, convoId]
      ,transition: Transition.rightToLeft)!.whenComplete(() {
        debugPrint('COMPLETE');
        lastMesRef = lastMesRef.withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data()!,
          toFirestore: (data, _) => data,
        );
        convoList.refresh();
        update();
    });
  }






  void onPageChanged (int index){
    page.value = index;
    pageController.jumpToPage(index);
    update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    _subscribeToConversations();
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    debugPrint(user.uid);
    isLoading.value=true;  
    update();
    tabTitles = ['Home', 'Conversations', 'Collaborations'];
    bottomTabs = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined,),
        label: 'Home',
        activeIcon: Icon(Icons.home_outlined, color: lightColorScheme.primary,),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.chat,),
        label: 'Conversations',
        activeIcon: Icon(Icons.chat, color: lightColorScheme.primary,),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.group,),
        label: 'Collaborations',
        activeIcon: Icon(Icons.group, color: lightColorScheme.primary,),
      )
    ];
    pageController = PageController(initialPage: page.value);
    await loadProfile(partial: false);
    fetchProjectList();
    isLoading.value=false;
    print("INTERESTS :::: "+interests.toString());
    update();
  }

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }

  showSnackBar({
    String? title,
    String? message
  }){
    Get.rawSnackbar(
      backgroundColor: Colors.white,
      boxShadows: [
        const BoxShadow(
          spreadRadius: 1,
          blurRadius: 4
        )
      ],
      barBlur: 0.7,
      overlayBlur: 0.9,
      borderRadius: 15,
      icon: const SizedBox(height: 25, width: 25, child: RiveAnimation.asset('assets/animation/tristructure.riv',)),
      progressIndicatorBackgroundColor: lightColorScheme.secondaryContainer,
      titleText: Text('Loading. Please wait...', style: TextStyle(fontSize: Constants.textM),),
      messageText: Text('Swipe to dismiss', style: TextStyle(fontSize: Constants.textS)),
      shouldIconPulse: true,
      // showProgressIndicator: true,
      duration: const Duration(minutes: 30),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      isDismissible: true,
      margin: const EdgeInsets.only(top: kBottomNavigationBarHeight, left: 16, right: 16),
      dismissDirection: DismissDirection.horizontal,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.TOP
    );
  }
  
  
}

class HomeBinding extends Bindings{
  
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.find<HomeController>();
  }

}