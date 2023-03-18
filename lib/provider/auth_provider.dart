// import 'package:porto_space/provider/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// enum Status {
//   uninitizialized,
//   authenticated,
//   authenticating,
//   authenticateError,
//   authenticateCanceled
// }

// class AuthProvider extends ChangeNotifier{
//   late GoogleSignIn googleSignIn;
//   late FirebaseAuth firebaseAuth;
//   late FirebaseFirestore firebaseFirestore;
//   late SharedPreferences sharedPreferences;

//   Status get status => _status;
//   AuthProvider({
//     required this.firebaseAuth,
//     required this.googleSignIn,
//     required this.firebaseFirestore,
//     required this.sharedPreferences
//   })

//   String? getUserFirebaseId(){
//     return sharedPreferences.getString(FirestoreConstants.id);

//   }
// }

// class FirestoreConstants{
//   static const pathUserCollection =  "users";
//   static const pathMessageCollection = "message";
//   static const firstName = "firstName";
//   static const lastName = "lastName";
//   static const profPicUrl = "profPicUrl";
//   static const id = "id";
//   static const conversationsList = "conversationsList";
//   static const linksList = "linksList";
//   static const careerHistory = "careerHistory";
//   static const educationHistory = "educationHistory";
// }