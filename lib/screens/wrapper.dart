import 'package:flutter/material.dart';
import 'package:science_club/screens/authenticate/authenticate.dart';
import 'package:science_club/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:science_club/models/registered.dart';
import 'package:science_club/shared/variables.dart';

import '../shared/loading.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Registered?>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return ValueListenableBuilder(
          valueListenable: globaluid,
          builder: (BuildContext context, String? value, Widget? child) {
            if (globaluid.value != null) {
              return Home();
            } else {
              return Loading();
            }
          });
    }
  }
}
