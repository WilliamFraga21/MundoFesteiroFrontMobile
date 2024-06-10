import 'package:flutter/foundation.dart';

class User {
  final int id;
  final String name;
  final String? photoUrl;

  User({required this.id, required this.name, required this.photoUrl});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      photoUrl: map['photoUrl'] as String,
    );
  }
}
