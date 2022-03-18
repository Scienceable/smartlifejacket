import 'package:science_club/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:science_club/shared/variables.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:science_club/shared/constants.dart';
import 'package:science_club/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleViewIntro;
  final Function toggleViewSignIn;

  SignIn( this.toggleViewIntro, this.toggleViewSignIn );

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  // text field state
  String email = '';
  String password = '';
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.orange[200],
        elevation: 0.0,
        title: const Text('Sign in'),
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
            label: const Text('Register'),
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
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val!.isEmpty ? 'Enter a password' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              RaisedButton(
                  color: Colors.pink[400],
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
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
                    'Other methods to sign in',
                  style: TextStyle(color: Colors.amberAccent),
                ),
              ),
              ElevatedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                  label: const Text('Sign in with Google'),
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
              RaisedButton(
                child: const Text('Sign in anonymously'),
                  onPressed: () async {
                    {
                      setState(() => loading = true);
                      dynamic result = await _auth.signInAnon();
                      if(result == null) {
                        setState(() {
                          errorFromFirebase = errorFromFirebase;
                          loading = false;
                        });
                      }
                    }
                  }
              ),
              SizedBox(height: 12.0,),
              Text(
                errorFromFirebase,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
      )
    );
  }
}
