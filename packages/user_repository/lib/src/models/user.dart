import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  User({
    required this.uID,
    required this.username,
    required this.email,
    this.photoURL,
    this.title,
    this.personalWebsiteURL,
    required this.userGroups,
  });

  final String uID;
  final String username;
  final String email;
  final String? photoURL;
  final String? title;
  final String? personalWebsiteURL;
  final List<String> userGroups;

  User copyWith({
    String? uID,
    String? username,
    String? email,
    String? photoURL,
    String? title,
    String? personalWebsiteURL,
    List<String>? userGroups,
  }) {
    return User(
      uID: uID ?? this.uID,
      username: username ?? this.username,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      title: title ?? this.title,
      personalWebsiteURL: personalWebsiteURL ?? this.personalWebsiteURL,
      userGroups: userGroups ?? this.userGroups,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uID': uID,
      'username': username,
      'email': email,
      'photoURL': photoURL,
      'title': title,
      'personalWebsiteURL': personalWebsiteURL,
      'userGroups': userGroups,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uID: map['uID'],
      username: map['username'],
      email: map['email'],
      photoURL: map['photoURL'],
      title: map['title'],
      personalWebsiteURL:
          map['personalWebsiteURL'],
      userGroups: List<String>.from(map['userGroups']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(uID: $uID, username: $username, email: $email, photoURL: $photoURL, title: $title, personalWebsiteURL: $personalWebsiteURL, userGroups: $userGroups)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uID == uID &&
        other.username == username &&
        other.email == email &&
        other.photoURL == photoURL &&
        other.title == title &&
        other.personalWebsiteURL == personalWebsiteURL &&
        listEquals(other.userGroups, userGroups);
  }

  @override
  int get hashCode {
    return uID.hashCode ^
        username.hashCode ^
        email.hashCode ^
        photoURL.hashCode ^
        title.hashCode ^
        personalWebsiteURL.hashCode ^
        userGroups.hashCode;
  }
}
