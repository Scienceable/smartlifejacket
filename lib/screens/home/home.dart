import 'package:flutter/material.dart';
import 'package:science_club/screens/home/bottom_navigation_bar.dart';

import 'package:science_club/screens/home/screen_selection.dart';
import 'package:science_club/screens/home/settings_form.dart';
import 'package:science_club/services/auth.dart';
import 'package:science_club/services/database.dart';
import 'package:provider/provider.dart';
import 'package:science_club/shared/variables.dart';

import '../../models/member.dart';
import '../../models/registered.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Member>?>.value(
        value: DatabaseService(globaluid.value).member,
        initialData: null,
        child: StreamBuilder<RegisteredData?>(
            stream: DatabaseService(globaluid.value).registeredData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                RegisteredData? registeredData = snapshot.data;
                userName = registeredData?.name;
                userEmail = registeredData?.email;
                userPhoneNumber = registeredData?.phoneNumber;
                userPhotoURL = registeredData?.photoUrl;
                userIsAnon = registeredData?.isAnon;
                return Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Colors.grey[100],
                  appBar: AppBar(
                    title: const Text('Science Club'),
                    backgroundColor: Colors.orange[200],
                    elevation: 0.0,
                    actions: <Widget>[
                      FlatButton.icon(
                        icon: const Icon(Icons.settings),
                        label: const Text('Settings'),
                        onPressed: () {
                          _showSettingsPanel();
                        },
                      ),
                      FlatButton.icon(
                        icon: const Icon(Icons.person),
                        label: const Text('Logout'),
                        onPressed: () async {
                          if (registeredData?.isAnon != false) {
                            await DatabaseService(globaluid.value).deleteUserData();
                            await _auth.deleteUser();
                          }
                          await _auth.signOut();
                          screenIndex.value = 0;

                        },
                      ),
                    ],
                  ),
                  body: const ScreenSelection(),
                  bottomNavigationBar: BottomNavigationBarWidget(),
                );
              } else {
                return Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Colors.grey[100],
                  appBar: AppBar(
                    title: const Text('Science Club'),
                    backgroundColor: Colors.orange[200],
                    elevation: 0.0,
                    actions: <Widget>[
                      FlatButton.icon(
                        icon: const Icon(Icons.settings),
                        label: const Text('Settings'),
                        onPressed: () {
                          _showSettingsPanel();
                        },
                      ),
                      FlatButton.icon(
                        icon: const Icon(Icons.person),
                        label: const Text('Logout'),
                        onPressed: () async {
                          if (userIsAnon != false) {
                            await DatabaseService(globaluid.value).deleteUserData();
                            await _auth.deleteUser();
                          }
                          await _auth.signOut();
                          screenIndex.value = 0;
                        },
                      ),
                    ],
                  ),
                  body: const ScreenSelection(),
                  bottomNavigationBar: BottomNavigationBarWidget(),
                );
              }
            }));
  }
}
