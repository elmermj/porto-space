import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:porto_space/screens/home/screens/home_screen.dart';
import 'package:porto_space/screens/profile/profile_edit_screen.dart';


class EntranceController extends GetxController {
  final state = EntranceState();
  get appBar => state._appBar;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var isLoading = false.obs;

  void showAppBar(){
    state._appBar = true.obs;
    update(); 
  }

  void hideAppBar(){
    state._appBar = false.obs;
    update();
  }

  EntranceController();
  

  final firebaseFirestore = FirebaseFirestore.instance;

  Future<void> signInWithGoogle()async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      final User user = userCredential.user!;
      final bool isNewUser = userCredential.additionalUserInfo!.isNewUser;

      final CollectionReference users = FirebaseFirestore.instance.collection('users');
      final db = mongo.Db('mongodb+srv://mattelmer24:<password>@cluster0.oviu9z4.mongodb.net/?retryWrites=true&w=majority');
      final mongoUsers = db.collection('users');

      if (isNewUser) {

        await users.doc(user.uid).set({
          'name': user.displayName!,
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        });

        isLoading.value = false;
        update();

        Get.off(ProfileEditScreen(isNew: true,));

      }else{

        await users.doc(user.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        });

        isLoading.value = false;
        update();

        Get.off(HomeScreen());

      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

class EntranceState {
  var index = 0.obs;
  var _appBar = false.obs;
}

class EntranceBinding extends Bindings{
  
  @override
  void dependencies() {
    Get.lazyPut<EntranceController>(() => EntranceController());
  }

}