import 'package:google_sign_in/google_sign_in.dart';
import 'package:mathy/models/firebase/users.dart';
import 'package:mathy/services/database/database_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

// login user
  Future loginUser(final String _email, final String _pass) async {
    try {
      final _result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _pass);
      final FirebaseUser _user = _result.user;
      _userFromFirebase(_user);
      return _user.uid;
    } catch (e) {
      return "$e myError";
    }
  }

// sign up user
  Future signUpUser(final String _userName, final String _userEmail,
      final String _userPass) async {
    try {
      final _result = await _auth.createUserWithEmailAndPassword(
          email: _userEmail, password: _userPass);
      final FirebaseUser _user = _result.user;
      await DatabaseProvider(uid: _user.uid)
          .sendUserDetail(_userName, _userEmail, 0, 5);
      _userFromFirebase(_user);
      return _user.uid;
    } catch (e) {
      return "$e myError";
    }
  }

// sign in with google
  Future signInWithGoogle() async {
    try {
      final _googleUser = await _googleSignIn.signIn();
      final _googleAuth = await _googleUser.authentication;
      final _cred = GoogleAuthProvider.getCredential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

      final _result = await _auth.signInWithCredential(_cred);
      FirebaseUser _user = _result.user;

      final _googleResult = await DatabaseProvider(uid: _user.uid).getGoogleIfExist();

      if (!_googleResult) {
        await DatabaseProvider(uid: _user.uid)
            .sendUserDetail(_user.displayName, _user.email, 0, 5);
      }

      _userFromFirebase(_user);

      return _user.uid;
    } catch (e) {
      return "$e myError";
    }
  }

// sign out user
  Future signOutUser() async {
    await _auth.signOut();
    final _isGoogleLoged = await _googleSignIn.isSignedIn();
    if (_isGoogleLoged) {
      _googleSignIn.signOut();
    }
  }

// user from firebase
  UserDetail _userFromFirebase(FirebaseUser _user) {
    return _user != null ? UserDetail(uid: _user.uid) : null;
  }

// stream of user
  Stream<UserDetail> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }
}
