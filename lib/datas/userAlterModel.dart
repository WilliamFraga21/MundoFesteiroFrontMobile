import 'package:flutter/foundation.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String contactNo;
  final int? localidadeId;
  final String? photo; // Campo photo pode ser null

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNo,
    this.localidadeId,
    this.photo, // photo é opcional
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      contactNo: json['contactno'].toString(),
      localidadeId: json['localidade_id'],
      photo: json['photo'], // Inicializa photo, que pode ser null
    );
  }
}
