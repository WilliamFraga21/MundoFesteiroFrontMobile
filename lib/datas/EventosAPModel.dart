class EventoAP {
  final int evento_id;
  final String nomeEvento;
  final String tipoEvento;
  final String descricaoEvento;
  final String? evento_imagem;

  EventoAP({
    required this.evento_id,
    required this.nomeEvento,
    required this.tipoEvento,
    required this.descricaoEvento,
    required this.evento_imagem,
  });

  factory EventoAP.fromJson(Map<String, dynamic> json) {
    return EventoAP(
      evento_id: json['evento_id'] ?? 0,
      nomeEvento: json['nomeEvento'] ?? '',
      tipoEvento: json['tipoEvento'] ?? '',
      descricaoEvento: json['descricaoEvento'] ?? '',
      evento_imagem: json['evento_imagem'],
    );
  }
}

class EventoAPModel {
  final EventoAP eventoAP;

  EventoAPModel({
    required this.eventoAP,
  });

  factory EventoAPModel.fromJson(Map<String, dynamic> json) {
    return EventoAPModel(
      eventoAP: EventoAP.fromJson(json),
    );
  }
}
