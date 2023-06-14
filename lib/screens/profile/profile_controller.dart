import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:porto_space/models/supports.dart';
import 'package:porto_space/screens/entrance/entrance_index.dart';
import 'package:porto_space/screens/home/home_index.dart';

class ProfileController extends GetxController{
  final bool isNew;
  String? dob;
  RxString name = ' '.obs, city = ' '.obs, occupation = ' '.obs, currentCompany = ' '.obs;
  User user = FirebaseAuth.instance.currentUser!;
  var isLoading = false.obs;

  Rx<DateTime>? selectedDate;
  final textEditName = TextEditingController();
  final textEditOccupation = TextEditingController();
  final textEditCurrentCompany = TextEditingController();
  final textEditCity = TextEditingController();

  ProfileController({required this.isNew}){
    loadProfile();
    if (dob != null) {
      selectedDate = Rx<DateTime>(DateTime.parse(dob!));
    } else {
      selectedDate = Rx<DateTime>(DateTime.now());
    }
  }

  void rxOnTap(BuildContext context){
    FocusScope.of(context).unfocus();
    update();
  }

  RxBool isKeyboardVisible = false.obs;
  void visibleKeyboard(var details){
    if (isKeyboardVisible.value) {
        isKeyboardVisible = false.obs;
        update();
    }
    update();
  }

  selectDate(BuildContext context) async {
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isNew || dob==null|| selectedDate == null)? DateTime.now():selectedDate!.value, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day
      ),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate!.value = picked;
      update();  
    }else if (dob != null) {  // Add this else block
      selectedDate = Rx<DateTime>(DateTime.parse(dob!));
      update();
    }
  }

  submitChanges({required bool isNew}) async {
    isLoading.value = true;
    update();
    
    if(isNew){
      textEditName.text = user.displayName!;
      FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "name": textEditName.text,
        "email": user.email,
        "dob": selectedDate!.value.toString().substring(0, 10), 
        "city": textEditCity.text,
        "occupation": textEditOccupation.text,
        "currentCompany": textEditCurrentCompany.text
      });

      name.value = textEditName.text;
      await user.updateDisplayName(textEditName.text);
      dob = selectedDate!.value.toString().substring(0, 10);
      city.value = textEditCity.text;
      occupation.value = textEditOccupation.text;
      currentCompany.value = textEditCurrentCompany.text;

      isLoading.value = false;
      
      update();
      Get.offAll(HomeScreen());
    }else{      
      FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "name": textEditName.text,
        "dob": selectedDate!.value.toString().substring(0, 10), 
        "city": textEditCity.text,
        "occupation": textEditOccupation.text,
        "currentCompany": textEditCurrentCompany.text
      });
      
      await user.updateDisplayName(textEditName.text);

      dob = selectedDate!.value.toString().substring(0, 10);
      city.value = textEditCity.text;
      occupation.value = textEditOccupation.text;
      currentCompany.value = textEditCurrentCompany.text;

      isLoading.value = false;
      
      update();
      Get.back();
    }

    if (kDebugMode) {
      debugPrint("name: $name dob: $dob city: ${city.value}");
    }
  }

  loadProfile() async {
    isLoading.value = true;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    
    name.value = data['name'];

    dob = data['dob'];

    if(data['city']!=null) city.value = data['city'];

    if(data['occupation']!=null) occupation.value = data['occupation'];

    if(data['currentCompany']!=null) currentCompany.value = data['currentCompany'];

    if(data['occupation']=='Unemployed' || data['occupation']==null) current.value = true;

    isNew? textEditName.text = user.displayName! : textEditName.text = name.value;
    textEditName.text == ' '? textEditName.text = user.displayName! : textEditName.text = data['name'];
    textEditCity.text = city.value;
    textEditOccupation.text = occupation.value;
    textEditCurrentCompany.text = currentCompany.value;

    if (dob != null) {
      selectedDate!.value = DateTime.parse(dob!);
    }

    debugPrint("name: $name dob: $dob city: ${city.value}");
    isLoading.value = false;
    
    update();

  }

  eraseAccount() async {
    try {
      var userProfile = FirebaseFirestore.instance.collection("users").doc(user.uid);
      var userEduHistory = await  FirebaseFirestore.instance
                            .collection("users").doc(user.uid)
                            .collection("educationHistory").get();
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in userEduHistory.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      await userProfile.delete();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      await user.reauthenticateWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        )
      );

      await user.delete();

      await FirebaseAuth.instance.signOut();
      Get.offAll(EntranceScreen());

      return true;

    } catch (e) {

      if (kDebugMode) {
        debugPrint(e.toString());
      }

      return null;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    // loadDataFromLocalStorage(city: textEditCity.text, birthdate: selectedDate!.value);
    loadCities();
    loadProfile();

    super.onInit();
  }

  final RxString selectedCity = "".obs;
  List<City> cities = [];

  Future<void> loadCities() async {
    final data = await rootBundle.loadString('assets/json/cities - 2400.json');
    final List<dynamic> jsonResult = json.decode(data);

    cities = jsonResult.map((e) => City.fromJson(e)).toList();
  }

  List<City> searchCity(String query) {
    return cities
        .where((city) => city.cityName.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
  }

  RxBool current = false.obs;

  final TextEditingController searchController = TextEditingController();

  
  toggleUnemployed({required bool current}){
    if (current==true){
      textEditOccupation.text = 'Unemployed';
      textEditCurrentCompany.text = 'None';
    }else{
      textEditOccupation.text = occupation.value;
      textEditCurrentCompany.text = currentCompany.value;
    }
    update();
  }
}



class ProfileBinding extends Bindings{
  final bool isNew;

  ProfileBinding({required this.isNew});
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController(isNew: isNew));
  }

}