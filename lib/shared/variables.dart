import 'package:flutter/material.dart';

String errorFromFirebase = '';
ValueNotifier<String?> globaluid = ValueNotifier<String?>('');

String? userName = '';
String? userEmail = '';
String? userPhoneNumber = '';
String? userPhotoURL = '';
bool? userIsAnon;
ValueNotifier<int?> screenIndex = ValueNotifier<int?>(0);

ValueNotifier<String?> newimageURL = ValueNotifier<String?>(null);