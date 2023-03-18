// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';

// UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

// String userDataToJson(UserData data) => json.encode(data.toJson());

// class UserData {
//   UserData({
//     this.id,
//     this.city,
//     this.createdAt,
//     this.dob,
//     this.email,
//     this.lastLoginAt,
//     this.name,
//   });

//   String? id;
//   String? city;
//   String? createdAt;
//   DateTime? dob;
//   String? email;
//   String? lastLoginAt;
//   String? name;

//   UserData copyWith({
//     String? id,
//     String? city,
//     String? createdAt,
//     DateTime? dob,
//     String? email,
//     String? lastLoginAt,
//     String? name,
//   }) => 
//     UserData(
//       id: id ?? this.id,
//       city: city ?? this.city,
//       createdAt: createdAt ?? this.createdAt,
//       dob: dob ?? this.dob,
//       email: email ?? this.email,
//       lastLoginAt: lastLoginAt ?? this.lastLoginAt,
//       name: name ?? this.name,
//     );

//   factory UserData.fromJson(Map<String, dynamic> json) => UserData(
//     id: json["id"],
//     city: json["city"],
//     createdAt: json["createdAt"],
//     dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
//     email: json["email"],
//     lastLoginAt: json["lastLoginAt"],
//     name: json["name"],
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "city": city,
//     "createdAt": createdAt,
//     "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
//     "email": email,
//     "lastLoginAt": lastLoginAt,
//     "name": name,
//   };

//   factory UserData.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> snapshot,
//     SnapshotOptions? options,
//   ){
//     final userData = snapshot.data();
//     return UserData(
//       name: userData?['name'],
//       email: userData?['email'],
//       dob: userData?['dob'],
//       city: userData?['city'],
//       createdAt: userData?['createdAt'],
//       lastLoginAt: userData?['lastLoginAt']
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       if (name != null) "name": name,
//       if (email != null) "email": email,
//       if (dob != null) "dob": dob,
//       if (city != null) "city": city,
//       if (createdAt != null) "createdAt": createdAt,
//       if (lastLoginAt != null) "lastLoginAt": lastLoginAt,
//     };
//   }
// }
