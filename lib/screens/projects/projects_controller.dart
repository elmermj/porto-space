import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:porto_space/models/project_item.dart';
import 'package:porto_space/models/project_member.dart';

class ProjectsController extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser!;

  ProjectsController();
  ProjectItem? projectData;
  String? projectId;
  RxList<ProjectMember> projectMemberList=<ProjectMember>[].obs;

  var tweenEndValue = 0.0.obs;
  var scaleValue = 1.0.obs;
  var scaleRValue = 0.0.obs;
  var slideValue = 0.2.obs;

  tweenAnimate(){
    tweenEndValue.value == 0.1? tweenEndValue.value= 0:tweenEndValue.value=0.1;
    scaleValue.value == 0.8? scaleValue.value=1: scaleValue.value=0.8;
    scaleRValue.value == 0.2? scaleRValue.value=0: scaleRValue.value=0.2;
    slideValue.value == 0.0? slideValue.value=0.2: slideValue.value=0.0;
    update();
  }

  fetchProjectMembers() async {
    print(projectId);
    projectMemberList.clear();
    var before = DateTime.now().millisecondsSinceEpoch;
    print('FETCHING DATA . . . .');
    var memberListQuery = await firestore
                          .collection('projects')
                          .doc(projectId)
                          .collection('members')
                          .orderBy('memName', descending: false)
                          .get();
    print("${memberListQuery.docs.asMap()}");

    for(var member in memberListQuery.docs){
      projectMemberList.add(
        ProjectMember(
          memberId: member.data()['memId'], 
          memberName: member.data()['memName'], 
          memberRole: member.data()['role']
        )
      );
      print('${member.data()['memName']}');
      update();
    }
    update();
    var after = DateTime.now().millisecondsSinceEpoch;
    var delta = after-before;
    print('DONE FETCHING . . . . ($delta ms)');
  }

  qrInvite(){
    
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final List passedData = Get.arguments;
    projectData = passedData[0];
    projectId = passedData[1];
    fetchProjectMembers();
  }

}

class ProjectsBinding extends Bindings{
  
  @override
  void dependencies() {
    Get.lazyPut<ProjectsController>(() => ProjectsController());
    Get.find<ProjectsController>();
  }

}