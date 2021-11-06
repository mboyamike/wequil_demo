import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:user_repository/user_repository.dart';

import 'authentication_repository_test.mocks.dart';

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
  });
}
