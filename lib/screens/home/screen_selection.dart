import 'package:flutter/material.dart';
import 'package:science_club/screens/home/member_list.dart';
import 'package:science_club/screens/home/project_list.dart';
import 'package:science_club/shared/loading.dart';
import 'package:science_club/shared/variables.dart';

class ScreenSelection extends StatefulWidget {
  const ScreenSelection({Key? key}) : super(key: key);

  @override
  State<ScreenSelection> createState() => _ScreenSelectionState();
}

class _ScreenSelectionState extends State<ScreenSelection> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: screenIndex,
        builder: (BuildContext context, int? value, Widget? child) {
          if (screenIndex.value == 0) {
            return MemberList();
          } else if (screenIndex.value == 1) {
            return ProjectList();
          } else {
            return Loading();
          }
        });
  }
}
