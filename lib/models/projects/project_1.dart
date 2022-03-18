import 'package:cloud_firestore/cloud_firestore.dart';

class Project1Data {

  final int? projectNumber;
  final String? projectName;
  final GeoPoint? deviceCoordinates;
  final int? depthActivated;
  final bool? isActivated;
  final String? photoURL;

  Project1Data( this.projectNumber ,this.projectName, this.deviceCoordinates, this.depthActivated, this.isActivated, this.photoURL );
}