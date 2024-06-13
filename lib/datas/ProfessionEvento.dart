class Profession {
  final int idProfessionPrestador;
  final String name;
  final String iconURL;
  final int quantidade;

  Profession({
    required this.idProfessionPrestador,
    required this.name,
    required this.iconURL,
    required this.quantidade,
  });

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(
      idProfessionPrestador: json['idProfessionPrestador'] ?? 0,
      name: json['name'] ?? 'Unknown', // Valor padrão se name for null
      iconURL: json['iconURL'] ?? '', // Valor padrão se iconURL for null
      quantidade: json['quantidade'] ?? '',
    );
  }
}
