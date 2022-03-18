import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:science_club/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:science_club/shared/variables.dart';

import 'package:science_club/shared/constants.dart';
import 'package:science_club/shared/loading.dart';
class Register extends StatefulWidget {

  final Function toggleViewSignIn;
  final Function toggleViewIntro;

  Register( this.toggleViewIntro, this.toggleViewSignIn, );



  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String name = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.orange[200],
        elevation: 0.0,
        title: const Text('Sign up'),
        actions: <Widget>[
          FlatButton.icon(
              icon: const Icon(Icons.home_filled),
              label: const Text('Main page'),
              onPressed: () {
                setState(() => errorFromFirebase = '');
                widget.toggleViewIntro();
              }
          ),
          FlatButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Sign In'),
            onPressed: () {
              setState(() => errorFromFirebase = '');
              widget.toggleViewSignIn();
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Name'),
                validator: (val) => val!.isEmpty ? 'Enter your name' : null,
                onChanged: (val) {
                  setState(() => name = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a password 6 or more characters long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              RaisedButton(
                  color: Colors.pink[400],
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                   if(_formKey.currentState!.validate()){
                     setState(() => loading = true);
                     dynamic result = await _auth.registerWithEmailAndPassword(name, email, password);
                     if(result == null) {
                     setState(() {
                     errorFromFirebase = errorFromFirebase;
                     loading = false;});
                     }
                   }
                  }
              ),
              const Divider(
                height: 30.0,
                thickness: 5.0,
              ),
              const SizedBox(
                height: 20.0,
                child: Text(
                  'Other methods to sign up',
                  style: TextStyle(color: Colors.amberAccent),
                ),
              ),
              ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                  label: const Text('Sign up with Google'),
                  onPressed: () async {
                    {
                      dynamic result = await _auth.signInWithGoogle();
                      if(result == null) {
                        setState(() {
                          errorFromFirebase = errorFromFirebase;
                        });
                      }
                    }
                  }
              ),
              const SizedBox(height: 12.0,),
              Text(
                errorFromFirebase,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
      )
    );
  }
}