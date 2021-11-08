import 'package:authentication_repository/src/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WebGoogleAuthProvider implements AuthProvider {
  WebGoogleAuthProvider(
      {GoogleAuthProvider? googleAuthProvider, FirebaseAuth? firebaseAuth})
      : _googleAuthProvider = googleAuthProvider ?? GoogleAuthProvider(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final GoogleAuthProvider _googleAuthProvider;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserCredential> signIn() {
    return _firebaseAuth.signInWithPopup(_googleAuthProvider);
  }
}
