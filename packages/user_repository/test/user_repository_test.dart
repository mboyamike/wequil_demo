import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:user_repository/src/src.dart';

void main() {
  group('UserRepository tests', () {
    late FakeFirebaseFirestore firestore;
    late UserRepository userRepository;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      firestore.collection('users').doc('001').set({
        'uID': '001',
        'username': 'Test User',
        'userGroups': ['admin'],
        'email': 'user@test.com',
        'photoURL': 'www.photo.com',
        'personalWebsiteURL': 'www.test.com',
      });

      userRepository = UserRepository(firestore: firestore);
    });

    test(
      'Fetches a user when given an existing uID',
      () async {
        final user = await userRepository.fetchUser(uID: '001');
        expect(user, isNotNull);
      },
    );

    test(
      'Returns null when no user with the given uID exists',
      () async {
        final user = await userRepository.fetchUser(uID: '002');
        expect(user, isNull);
      },
    );

    test('Saves a user when saveUser is called', () async {
      User? user = await userRepository.fetchUser(uID: '002');
      expect(user, isNull);
      await userRepository.saveUser(
        user: User(
          uID: '002',
          username: 'Test User',
          email: 'user@test.com',
          userGroups: ['guest'],
        ),
      );
      user = await userRepository.fetchUser(uID: '002');
      expect(user, isNotNull);
    });

    test('fetches a list of users', () async {
      final usersList = await userRepository.fetchUsers();
      expect(usersList, isNotEmpty);
    });
  });
}
