import 'package:flutter/material.dart';
import 'package:science_club/shared/variables.dart';

class BottomNavigationBarWidget extends StatefulWidget {

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      screenIndex.value = _selectedIndex;
    });
  }
  @override

  Widget build(BuildContext context) {

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messaging',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.science),
          label: 'Projects',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    backgroundColor: Colors.cyan,
    );
  }
}
