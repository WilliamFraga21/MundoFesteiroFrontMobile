class User {
  final int id;
  final String name;
  final String email;
  final String contactNo;
  // ignore: non_constant_identifier_names
  final int localidade_id;
  final String? status;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNo,
    // ignore: non_constant_identifier_names
    required this.localidade_id,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      contactNo: json['contactno'].toString(),
      localidade_id: json['localidade_id'],
      status: json['Status'],
    );
  }
}

class Evento {
  final int id;
  final String nomeEvento;
  final String tipoEvento;
  final String data;
  final int quantidadePessoas;
  final int quantidadeFuncionarios;
  final String statusEvento;
  final String descricaoEvento;
  final int usersId;
  final int localidadeId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Evento({
    required this.id,
    required this.nomeEvento,
    required this.tipoEvento,
    required this.data,
    required this.quantidadePessoas,
    required this.quantidadeFuncionarios,
    required this.statusEvento,
    required this.descricaoEvento,
    required this.usersId,
    required this.localidadeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      nomeEvento: json['nomeEvento'],
      tipoEvento: json['tipoEvento'],
      data: json['data'],
      quantidadePessoas: json['quantidadePessoas'],
      quantidadeFuncionarios: json['quantidadeFuncionarios'],
      statusEvento: json['statusEvento'],
      descricaoEvento: json['descricaoEvento'],
      usersId: json['users_id'],
      localidadeId: json['localidade_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}

class LocalidadeEvento {
  final int id;
  final String endereco;
  final String bairro;
  final String cidade;
  final String estado;
  final String createdAt;
  final String updatedAt;

  LocalidadeEvento({
    required this.id,
    required this.endereco,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocalidadeEvento.fromJson(Map<String, dynamic> json) {
    return LocalidadeEvento(
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

class Profissao {
  final String profissao;
  final int profissaoId;
  final int quantidade;

  Profissao({
    required this.profissao,
    required this.profissaoId,
    required this.quantidade,
  });

  factory Profissao.fromJson(Map<String, dynamic> json) {
    return Profissao(
      profissao: json['profissao'],
      profissaoId: json['profissao_id'],
      quantidade: json['quantidade'],
    );
  }
}

class EventoModel {
  final User user;
  final Evento evento;
  final LocalidadeEvento localidadeEvento;
  final List<Profissao> profissao;
  final String? photo;
  EventoModel({
    required this.user,
    required this.evento,
    required this.localidadeEvento,
    required this.profissao,
    required this.photo,
  });

  factory EventoModel.fromJson(Map<String, dynamic> json) {
    var list = json['profissao'] as List;
    List<Profissao> profissaoList =
        list.map((i) => Profissao.fromJson(i)).toList();

    final photo = json['photo'] as String?;
    return EventoModel(
      user: User.fromJson(json['user']),
      evento: Evento.fromJson(json['evento']),
      localidadeEvento: LocalidadeEvento.fromJson(json['localidadeEvento']),
      profissao: profissaoList,
      photo: photo,
    );
  }
}
