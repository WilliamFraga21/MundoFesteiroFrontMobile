class InfosUserProposta {
  final String name;
  final String email;
  final int contactno;
  final int userID;
  final int propostaID;
  final String profissao;
  final int aceitarProposta;
  final int prestadorId;
  final String dataProposta;

  InfosUserProposta({
    required this.name,
    required this.email,
    required this.contactno,
    required this.userID,
    required this.propostaID,
    required this.profissao,
    required this.aceitarProposta,
    required this.prestadorId,
    required this.dataProposta,
  });

  factory InfosUserProposta.fromJson(Map<String, dynamic> json) {
    return InfosUserProposta(
      name: json['name'],
      email: json['email'],
      contactno: json['contactno'],
      userID: json['userID'],
      propostaID: json['propostaID'],
      profissao: json['profissao'],
      aceitarProposta: json['aceitarProposta'],
      prestadorId: json['prestador_id'],
      dataProposta: json['dataProposta'],
    );
  }
}

class Proposta {
  final InfosUserProposta infosUserProposta;
  final String? photo;

  Proposta({
    required this.infosUserProposta,
    this.photo,
  });

  factory Proposta.fromJson(Map<String, dynamic> json) {
    return Proposta(
      infosUserProposta: InfosUserProposta.fromJson(json['infosUserProposta']),
      photo: json['photo'],
    );
  }
}
