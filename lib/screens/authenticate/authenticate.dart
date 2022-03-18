import 'package:science_club/screens/authenticate/register.dart';
import 'package:science_club/screens/authenticate/sign_in.dart';
import 'package:science_club/screens/authenticate/intro.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showIntro = true;
  bool showSignIn = true;

  void toggleViewSignIn() {
    print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  void toggleViewIntro() {
    print(showIntro.toString());
    setState(() => showIntro = !showIntro);
  }

  void notToggleViewIntro() {
    print(showIntro.toString());
    setState(() => showIntro = showIntro);
  }

  void notToggleViewSignIn() {
    print(showSignIn.toString());
    setState(() => showSignIn = showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showIntro) {
      return Intro(toggleViewIntro, notToggleViewSignIn);
    } else if (showSignIn) {
      return SignIn(toggleViewIntro, toggleViewSignIn);
    } else {
      return Register(toggleViewIntro, toggleViewSignIn);
    }
  }
}

