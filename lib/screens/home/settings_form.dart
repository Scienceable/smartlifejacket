import 'package:provider/provider.dart';
import 'package:science_club/models/registered.dart';
import 'package:science_club/services/database.dart';
import 'package:science_club/services/image_uploads.dart';
import 'package:science_club/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:science_club/shared/loading.dart';

import '../../shared/variables.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String? _currentName;
  String? _currentEmail;
  String? _currentPhoneNumber;

  @override
  Widget build(BuildContext context) {
    Widget _profilePhoto() {
      print(newimageURL.value);

      if (newimageURL.value != null) {
        return Image(image: NetworkImage(newimageURL.value!));
      } else if (userPhotoURL != null) {
        return Image(image: NetworkImage(userPhotoURL!));
      } else {
        return Container();
      }
    }

    return ValueListenableBuilder(
        valueListenable: newimageURL,
        builder: (BuildContext context, String? value, Widget? child) {
          return SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Update your settings.',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          initialValue: userName,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Name'),
                          validator: (val) =>
                              val!.isEmpty ? 'Please enter a name' : null,
                          onChanged: (val) =>
                              setState(() => _currentName = val),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          initialValue: userEmail,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val!.isEmpty ? 'Please enter an email' : null,
                          onChanged: (val) =>
                              setState(() => _currentEmail = val),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          initialValue: userPhoneNumber,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Phone number'),
                          onChanged: (val) =>
                              setState(() => _currentPhoneNumber = val),
                        ),
                        const SizedBox(height: 10.0),
                        const Text('Update your profile picture.',
                            style: TextStyle(fontSize: 14.0),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 10.0),
                        _profilePhoto(),
                        const SizedBox(height: 10.0),
                        Row(children: <Widget>[
                          Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: RaisedButton(
                                color: Colors.deepOrange[400],
                                child: const Text(
                                  'Update profile photo',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  errorFromFirebase = '';
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageUploads()),
                                  );
                                }),
                          ),
                          newimageURL.value != null
                              ? Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                                  child: RaisedButton(
                                      color: Colors.red[400],
                                      child: const Text(
                                        'Discard',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          newimageURL.value = null;
                                        });
                                      }))
                              : Container(),
                        ]),
                        const SizedBox(height: 10.0),
                        RaisedButton(
                            color: Colors.pink[400],
                            child: const Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await DatabaseService(globaluid.value)
                                    .updateUserData(
                                        _currentName ?? userName,
                                        _currentEmail ?? userEmail,
                                        _currentPhoneNumber ?? userPhoneNumber,
                                        newimageURL.value ?? userPhotoURL,
                                        userIsAnon!);
                                userName = _currentName;
                                userEmail = _currentEmail;
                                userPhoneNumber = _currentPhoneNumber;
                              }
                            }),
                      ],
                    ),
                  )));
        });
  }
}
