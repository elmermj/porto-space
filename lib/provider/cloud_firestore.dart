import 'package:cloud_firestore/cloud_firestore.dart';

class UserQuery {
  final String userId;
  final String name;
  final String currentCity;
  final String currentJob;
  final String currentCompany;
  final String? lastEducation;
  final bool jobSeekingStatus;
  final List<dynamic>? educationHistory;
  final List<dynamic>? careerHistory;
  final List<dynamic>? achievements;
  final List<dynamic>? myJourney;
  final List<dynamic>? ongoingConversations;
  final List<dynamic>? collaborations;

  UserQuery({
    required this.userId,
    required this.name,
    required this.currentCity,
    required this.currentJob,
    required this.currentCompany,
    this.lastEducation,
    required this.jobSeekingStatus,
    this.educationHistory,
    this.careerHistory,
    this.achievements,
    this.myJourney,
    this.ongoingConversations,
    this.collaborations,
  });

  factory UserQuery.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data as Map;

    return UserQuery(
      userId: data['userId'],
      name: data['name'],
      currentJob: data['currentJob'],
      currentCity: data['currentCity'],
      currentCompany: data['currentCompany'], 
      lastEducation: data['lastEducation']??null,
      jobSeekingStatus: data['jobSeekingStatus'],
      educationHistory: data['eduHistory']??null,
      careerHistory: data['careerHistory']??null,
      achievements: data['achievements']??null,
      myJourney: data['myJourney']??null,
      ongoingConversations: data['on-conv']??null, 
    );
  }
}

Future<UserQuery?> getUserData(String userId) async {
  final DocumentReference document =
      FirebaseFirestore.instance.collection("UserQuery").doc(userId);

  DocumentSnapshot snapshot = await document.get();

  if (snapshot.exists) {
    return UserQuery.fromFirestore(snapshot);
  } else {
    return null;
  }
}

Future<List<UserQuery>> getAllUserData() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection("UserQuery").get();

  return snapshot.docs.map((doc) => UserQuery.fromFirestore(doc)).toList();
}
