class Prestador {
  final int id;
  final int usersId;
  final int promotorEvento;
  final String name;
  final String email;
  final String contactNo;
  final String createdAt;
  final String curriculo;

  final String? status;

  Prestador({
    required this.id,
    required this.usersId,
    required this.promotorEvento,
    required this.name,
    required this.email,
    required this.contactNo,
    required this.createdAt,
    required this.curriculo,
    this.status,
  });

  factory Prestador.fromJson(Map<String, dynamic> json) {
    return Prestador(
      id: json['id'],
      usersId: json['users_id'],
      promotorEvento: json['promotorEvento'],
      name: json['name'],
      email: json['email'],
      contactNo: json['contactno'].toString(),
      createdAt: json['created_at'],
      curriculo: json['curriculo'],
      status: json['Status'],
    );
  }
}

class Profession2 {
  final int id;
  final String profissao;
  final int tempoExperiencia;
  final double valorDiaServicoProfissao;
  final double valorHoraServicoProfissao;

  Profession2({
    required this.id,
    required this.profissao,
    required this.tempoExperiencia,
    required this.valorDiaServicoProfissao,
    required this.valorHoraServicoProfissao,
  });

  factory Profession2.fromJson(Map<String, dynamic> json) {
    return Profession2(
      id: json['id'],
      profissao: json['profissao'],
      tempoExperiencia: json['tempoexperiencia'],
      valorDiaServicoProfissao: json['valorDiaServicoProfissao'].toDouble(),
      valorHoraServicoProfissao: json['valorHoraServicoProfissao'].toDouble(),
    );
  }
}

class LocalidadePrestador {
  final int id;
  final String endereco;
  final String bairro;
  final String cidade;
  final String estado;
  final String createdAt;
  final String updatedAt;

  LocalidadePrestador({
    required this.id,
    required this.endereco,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocalidadePrestador.fromJson(Map<String, dynamic> json) {
    return LocalidadePrestador(
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

class PrestadorModel {
  final Prestador prestador;
  final List<Profession2>? profession;
  final String? photo;
  final LocalidadePrestador localidadePrestador;
  PrestadorModel({
    required this.prestador,
    required this.profession,
    required this.photo,
    required this.localidadePrestador,
  });

  factory PrestadorModel.fromJson(Map<String, dynamic> json) {
    // Extrair dados do prestador
    final prestadorInfo = json['prestadorInfo'] as Map<String, dynamic>;
    final prestador = Prestador.fromJson(prestadorInfo);

    // Extrair dados da localidade do prestador
    final infoPrestadorEnd = json['infoPrestadorEnd'] as Map<String, dynamic>;
    final localidadePrestador = LocalidadePrestador.fromJson(infoPrestadorEnd);

    // Extrair dados das profissões (se disponível)
    final prestadorProfessions = json['prestadorprofessions'] as List<dynamic>?;

    List<Profession2>? profession;
    if (prestadorProfessions != null) {
      profession = prestadorProfessions
          .map((professionJson) => Profession2.fromJson(professionJson))
          .toList();
    }

    // Extrair dados da foto (se disponível)
    final photo = json['photo'] as String?;

    return PrestadorModel(
      prestador: prestador,
      profession: profession,
      localidadePrestador: localidadePrestador,
      photo: photo,
    );
  }
}
