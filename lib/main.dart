import 'package:flutter/material.dart';
import 'package:science_club/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:science_club/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:science_club/models/registered.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final AuthService _auth = AuthService();
  await _auth.updateUid();



  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
 build(BuildContext context)  {

    return StreamProvider<Registered?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}

