import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:science_club/models/registered.dart';
import 'package:science_club/services/database.dart';
import 'package:science_club/shared/variables.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Registered? _userFromFirebaseUser(User? user) {
    return user != null ? Registered(user.uid) : null;
  }

  // auth change user stream
  Stream<Registered?> get user {
    return _auth.authStateChanges()
    .map(_userFromFirebaseUser);
  }

  Future updateUid() async {
    try {
      globaluid.value = await _auth.currentUser!.uid;
      return null;
    } catch (e) {
      print(e.toString());
      errorFromFirebase = e.toString();
    }
  }
  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      await DatabaseService(user!.uid).updateUserData(user!.uid, user!.email, user!.phoneNumber, user!.photoURL, user!.isAnonymous);
      globaluid.value = user!.uid;
      print ('uid $globaluid');
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      errorFromFirebase = e.toString();
      return null;
    }
  }


// sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      globaluid.value = user!.uid;
      print ('uid $globaluid');
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      errorFromFirebase = e.toString();
      return null;
    }
  }

// register with email and password
  Future registerWithEmailAndPassword(String name, String email, String password) async{
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      
      //create a document for the user
      await DatabaseService(user!.uid).updateUserData(name, user!.email, user!.phoneNumber, user!.photoURL, user!.isAnonymous);
      globaluid.value = user!.uid;
      print ('uid $globaluid');
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      errorFromFirebase = e.toString();
    }
  }

// sign in with Google
  Future signInWithGoogle() async {
    try { // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser
          ?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
        await FirebaseAuth.instance.signInWithCredential(credential);
      await DatabaseService(_auth.currentUser?.uid).updateUserData(googleUser!.displayName, googleUser!.email, null, googleUser!.photoUrl, false);
      // Once signed in, return the UserCredential
      globaluid.value = _auth.currentUser?.uid;
      print ('uid $globaluid');
      return true;
    } catch (e){
      print(e.toString());
      errorFromFirebase = e.toString();
    }
    return false;
  }

// sign out
  Future signOut() async {
    try {
      await _auth.signOut();
      globaluid.value = null;
      return null;
    } catch (e) {
      print(e.toString());
      errorFromFirebase = e.toString();
      return null;
    }
  }

  // delete user
  Future deleteUser() async {
    try {
      User? user = await FirebaseAuth.instance.currentUser;
      return user?.delete();
    } catch(e){
      print(e.toString());
      errorFromFirebase = e.toString();
    }

  }
}

