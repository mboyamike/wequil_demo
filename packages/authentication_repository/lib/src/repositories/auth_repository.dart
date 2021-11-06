import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:user_repository/user_repository.dart';

class AuthRepository {
  AuthRepository({
    UserRepository? userRepository,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _userRepository = userRepository ?? UserRepository(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final UserRepository _userRepository;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  Stream<User?> userStream() {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      
      User? user = await _userRepository.fetchUser(uID: firebaseUser.uid);
      user ??= User(
        uID: firebaseUser.uid,
        username: firebaseUser.displayName ?? 'Guest',
        email: firebaseUser.email!,
        userGroups: ['guest'],
      );
      await _userRepository.saveUser(user: user);
      return user;
    });
  }


}
