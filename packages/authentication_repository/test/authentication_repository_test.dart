import 'dart:async';

import 'package:authentication_repository/src/models/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:user_repository/user_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'authentication_repository_test.mocks.dart';

class MockGoogleAuthProvider implements AuthProvider {
  MockGoogleAuthProvider({required this.auth});

  final MockFirebaseAuth auth;

  @override
  Future<firebase_auth.UserCredential> signIn() async {
    final googleSignIn = MockGoogleSignIn();
    final signinAccount = await googleSignIn.signIn();
    final googleAuth = await signinAccount!.authentication;
    final firebase_auth.AuthCredential credential =
        firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return auth.signInWithCredential(credential);
  }
}

@GenerateMocks([UserRepository])
void main() {
  group('authentication tests', () {
    late MockUserRepository userRepository = MockUserRepository();
    late AuthRepository authRepository;
    late MockFirebaseAuth mockFirebaseAuth;
    StreamSubscription? userStreamSubscription;

    final testUser = MockUser(
      email: 'user@test.com',
      displayName: 'Test User',
      photoURL: 'www.photo.com',
    );

    final testRepositoryUser = User(
      uID: '001',
      username: 'user@test.com',
      email: 'user@test.com',
      userGroups: ['guest'],
    );

    setUp(() {
      userRepository = MockUserRepository();
    });

    tearDown(() {
      userStreamSubscription?.cancel();
    });

    test('User is null before logging in', () {
      User? user;
      mockFirebaseAuth = MockFirebaseAuth(mockUser: testUser);
      authRepository = AuthRepository(
        userRepository: userRepository,
        firebaseAuth: mockFirebaseAuth,
      );
      userStreamSubscription = authRepository.userStream().listen((event) {
        user = event;
      });

      expect(user, isNull);
    });

    test('Sign in with third party provider', () async {
      User? user;
      mockFirebaseAuth = MockFirebaseAuth(mockUser: testUser);
      authRepository = AuthRepository(
        userRepository: userRepository,
        firebaseAuth: mockFirebaseAuth,
      );
      userStreamSubscription = authRepository.userStream().listen((event) {
        user = event;
      });

      when(userRepository.fetchUser(uID: anyNamed('uID')))
          .thenAnswer((realInvocation) async => testRepositoryUser);

      expect(user, isNull);
      final mockProvider = MockGoogleAuthProvider(auth: mockFirebaseAuth);
      await authRepository.signInWithAuthProvider(authProvider: mockProvider);
      await Future.delayed(Duration.zero);
      expect(user, isNotNull);
    });

    test('Signs Out', () async {
      User? user;
      mockFirebaseAuth = MockFirebaseAuth(signedIn: true);
      authRepository = AuthRepository(
        userRepository: userRepository,
        firebaseAuth: mockFirebaseAuth,
      );
      userStreamSubscription = authRepository.userStream().listen((event) {
        user = event;
      });
      when(userRepository.fetchUser(uID: anyNamed('uID')))
          .thenAnswer((realInvocation) async => testRepositoryUser);

      await Future.delayed(Duration.zero);
      expect(user, isNotNull);

      await authRepository.signOut();
      await Future.delayed(Duration.zero);
      expect(user, isNull);

    });
  });
}
