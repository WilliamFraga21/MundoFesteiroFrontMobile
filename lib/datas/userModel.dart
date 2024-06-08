class Localidade {
  final int id;
  final String endereco;
  final String bairro;
  final String cidade;
  final String estado;
  final String? createdAt;
  final String? updatedAt;

  Localidade({
    required this.id,
    required this.endereco,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.createdAt,
    this.updatedAt,
  });

  factory Localidade.fromJson(Map<String, dynamic> json) {
    return Localidade(
      id: json['id'],
      endereco: json['endereco'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      estado: json['estado'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String contactno;
  final String? status;
  final int localidadeId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.contactno,
    this.status,
    required this.localidadeId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      contactno: json['contactno'].toString(),
      status: json['Status'],
      localidadeId: json['localidade_id'],
    );
  }
}

class UserModel {
  final User user;
  final Localidade localidade;
  final String? photo;

  UserModel({
    required this.user,
    required this.localidade,
    required this.photo,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final photo = json['photo'] as String?;
    return UserModel(
      user: User.fromJson(json['user']),
      localidade: Localidade.fromJson(json['localidade']),
      photo: photo,
    );
  }
}
