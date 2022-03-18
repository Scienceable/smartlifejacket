import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:science_club/shared/variables.dart';
import 'dart:io';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class Intro extends StatefulWidget {

  final Function toggleViewIntro;
  final Function toggleViewSignIn;
  Intro( this.toggleViewIntro, this.toggleViewSignIn );

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {


  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {

    _launchURL() async {

      String url = 'https://cchs.brsd.ab.ca';
      await launch(
          url,
          forceSafariVC: true,
          forceWebView: true,
        );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.orange[200],
        elevation: 0.0,
        title: const Text('Welcome'),
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign in / Register'),
              onPressed: () {
                setState(() => errorFromFirebase = '');
                widget.toggleViewIntro();
              }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Column(
           children: <Widget>[
             Container(
               child: const Text(
                 'Please proceed to sign in / register in order to gain access to projects and others.',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 15.0),
               )
             ),
              RaisedButton(
                color: Colors.purpleAccent,
                onPressed: _launchURL,
                child: Text('School website'),
              ),
             _infoTile('App name', _packageInfo.appName),
             _infoTile('Package name', _packageInfo.packageName),
             _infoTile('App version', _packageInfo.version),
             _infoTile('Build number', _packageInfo.buildNumber),
             _infoTile('Build signature', _packageInfo.buildSignature),
             _infoTile('Operating system', Platform.operatingSystem.toString()),
             _infoTile('Number of processors', Platform.numberOfProcessors.toString()),
             _infoTile('Local host name', Platform.localHostname),
             _infoTile('Version', Platform.version),
             _infoTile('Resolved executable', Platform.resolvedExecutable),
           ],
          ),
      ),
    ),
    );
  }
}
