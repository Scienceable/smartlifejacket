import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:science_club/models/member.dart';
import 'package:science_club/models/projects/project_1.dart';
import 'package:science_club/models/registered.dart';

import '../models/project.dart';

final userCollection = FirebaseFirestore.instance.collection('users');
final projectCollection = FirebaseFirestore.instance.collection('projects');

class DatabaseService {
  final String? uid;

  DatabaseService(this.uid);

  // collection reference

  Future updateUserData(String? name, String? email, String? phoneNumber, String? photoUrl, bool isAnon) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'phone number': phoneNumber,
      'photo url': photoUrl,
      'isAnon': isAnon
    });
  }

  Future deleteUserData() async {
    return await userCollection.doc(uid).delete();
  }

  RegisteredData? _registeredDataFromSnapshot(DocumentSnapshot snapshot) {
    return RegisteredData(
        snapshot.get('uid') ?? 'Unknown',
        snapshot.get('name') ?? 'No name',
        snapshot.get('email') ?? 'No email',
        snapshot.get('phone number') ?? 'No phone number',
        snapshot.get('photo url') ?? 'Unknown',
        snapshot.get('isAnon') ?? true);
  }

  List<Member>? _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Member(
          doc.get('uid') ?? 'No uid',
          doc.get('name') ?? 'No name',
          doc.get('email') ?? 'No email',
          doc.get('phone number') ?? 'No phone number',
          doc.get('photo url') ?? 'No photo url',
          doc.get('isAnon') ?? true);
    }).toList();
  }

  Stream<List<Member>?> get member {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<RegisteredData?> get registeredData {
    return userCollection.doc(uid).snapshots().map(_registeredDataFromSnapshot);
  }

  //Projects

  List<Project>? _projectListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Project(
        doc.get('projectNumber') ?? 0,
        doc.get('projectName') ?? 'No name',
        doc.get('photoURL'),
      );
    }).toList();
  }

  Stream<List<Project>?> get project {
    return projectCollection.snapshots().map(_projectListFromSnapshot);
  }

  Future updateProject1(String? name, int? depthActivated, bool isActivated, String? photoURL) async {
    return await projectCollection.doc('1').update({
      'projectNumber': 1,
      'projectName': name,
      'depthActivated': depthActivated,
      'isActivated': isActivated,
      'photoURL': photoURL
    });
  }

  Project1Data? _project1DataFromSnapshot(DocumentSnapshot snapshot) {
    print(snapshot.data());
    return Project1Data(
        snapshot.get('projectNumber') ?? '1',
        snapshot.get('projectName') ?? 'No name',
        snapshot.get('deviceCoordinates') ?? const GeoPoint(0.0, 0.0),
        snapshot.get('depthActivated') ?? 0,
        snapshot.get('isActivated') ?? false,
        snapshot.get('photoURL'));
  }

  Stream<Project1Data?> get project1Data {
    return projectCollection.doc('1').snapshots().map(_project1DataFromSnapshot);
  }
}
