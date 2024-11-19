import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_crew/models/user.dart';
// import 'package:brew_crew/screens/home/settings_form.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  // create user obj based on firebase user

  User1? _userFromFirebaseUser(User? user){
    return user!=null ? User1(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User1?> get user {
    return _auth.authStateChanges()
      // .map((User? user) => _userFromFirebaseUser(user));
      .map(_userFromFirebaseUser);
  }

  //sign in anonymous
  Future signInAnon() async {
    try {
        UserCredential result = await _auth.signInAnonymously();
        User? user = result.user;
        return _userFromFirebaseUser(user!);
    } catch(e) {
        print(e.toString());
        return null;
    }
  }


  //sign in with email and password
  Future SignInWithEmailAndPasswd(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }


  //register with email and password
  Future resgisterWithEmailAndPasswd(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await DatabaseService(uid : user!.uid).updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }


  // sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }


}