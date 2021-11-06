import 'package:user_repository/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  UserRepository({
    FirebaseFirestore? firestore,
    DateTime? lastFetchFromFirebase,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _lastFetchFromFirestore = lastFetchFromFirebase ?? DateTime.now();

  final FirebaseFirestore _firestore;

  DateTime _lastFetchFromFirestore;
  final List<User> _usersList = [];
  bool _hasFetchedAllUsers = false;

  Future<User?> _fetchUserFromFirebase({required String uID}) async {
    final userDoc = await _firestore.collection('users').doc(uID).get();
    if (!userDoc.exists) {
      return null;
    }

    final userMap = userDoc.data()!;
    final userGroups = <String>[];

    for (final group in (userMap['userGroups'] ?? [])) {
      userGroups.add(group);
    }

    final user = User(
      uID: userMap['uID'],
      username: userMap['username'],
      email: userMap['email'],
      userGroups: userGroups,
      photoURL: userMap['photoURL'],
      personalWebsiteURL: userMap['personalWebsiteURL'],
    );

    return user;
  }

  Future<User?> fetchUser({
    required String uID,
    bool forceFetch = false,
  }) async {
    final timeSinceLastFetch =
        DateTime.now().difference(_lastFetchFromFirestore);
    final userIndex = _usersList.indexWhere((element) => element.uID == uID);
    if (userIndex != -1 && timeSinceLastFetch.inMinutes < 30 && !forceFetch) {
      return _usersList[userIndex];
    }

    final user = await _fetchUserFromFirebase(uID: uID);
    _lastFetchFromFirestore = DateTime.now();

    // To prevent duplication of users
    if (userIndex != -1) {
      _usersList.removeAt(userIndex);
    }

    if (user != null) {
      _usersList.add(user);
    }
    return user;
  }

  Future<void> saveUser({required User user}) async {
    return _firestore.collection('users').doc(user.uID).set(user.toMap());
  }

  /// Fetches a list of all users. The parameter called limit will limit the
  /// number of records if passed. If null, then all records will be fetched
  Future<List<User>> fetchUsers({
    bool forceFetch = false,
    int? limit,
  }) async {
    final timeSinceLastFetchFromFirestore =
        DateTime.now().difference(_lastFetchFromFirestore);

    bool shouldFetch =
        forceFetch || (timeSinceLastFetchFromFirestore.inMinutes >= 30);

    if (limit != null) {
      shouldFetch = shouldFetch || limit >= _usersList.length;
      if (limit <= _usersList.length) {
        return _usersList.sublist(0, limit);
      }
    }

    if (_hasFetchedAllUsers && !shouldFetch) {
      return _usersList;
    }

    final users = await _fetchUsersFromFirestore(limit: limit);
    if (users.length == _usersList.length && limit == null) {
      _hasFetchedAllUsers = true;
    }
    return users;
  }

  Future<List<User>> _fetchUsersFromFirestore({int? limit}) async {
    Query<Map<String, dynamic>> query =
        _firestore.collection('users').orderBy('username');

    if (limit != null) {
      query = query.limit(limit);
    }

    final querySnapshot = await query.get();
    final docs = querySnapshot.docs;
    final usersList = docs.map(_userFromQuerySnapshotDocument).toList();
    return usersList;
  }

  User _userFromQuerySnapshotDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final documentData = document.data();
    final userGroups = <String>[];
    for (final userGroup in documentData['userGroups']) {
      userGroups.add(userGroup);
    }
    return User(
      uID: documentData['uID'],
      username: documentData['username'] ?? 'Guest',
      email: documentData['email'],
      photoURL: documentData['photoURL'],
      personalWebsiteURL: documentData['personalWebsiteURL'],
      userGroups: userGroups,
    );
  }
}
