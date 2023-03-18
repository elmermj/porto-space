import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectItem {
  final String? projectId;
  final String? projectName;
  final String? projectAuthor;
  final String? projectDescription;
  final String? projectStatus;
  final int? memberCount;
  final Timestamp? timeCreated;
  final List<String>? projectKeywords;
  final List<String>? projectMemberList;

  ProjectItem({
    this.projectId, 
    this.projectName,
    this.projectAuthor, 
    this.projectDescription, 
    this.projectStatus, 
    this.memberCount, 
    this.timeCreated,
    this.projectKeywords, 
    this.projectMemberList,
  });

}