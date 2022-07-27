import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {   //Define methods that are gonna interact with firebase auth

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebase user
  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  //auth change user stream
  Stream <UserModel> get user {
    return _auth.authStateChanges()
      .map(_userFromFirebaseUser);
  }

  //sign in anon
    Future signInAnon() async {

      try {
       UserCredential result = await _auth.signInAnonymously();
       User user = result.user;
       return _userFromFirebaseUser(user);
    } catch (e) {
        print(e.toString());
        return null;
      }
    }

  //sign in email
  Future signinWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      //create new doc for user with uid
      await DatabaseService(uid: user.uid).updateUserDate('Juan', '0', 100);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return(null);
    }
  }

}