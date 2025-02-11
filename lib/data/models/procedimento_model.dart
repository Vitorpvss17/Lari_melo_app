class ProcedimentoModel {
  final int? id;
  final int clienteId;
  final String titulo;
  final String descricao;
  final double valor;
  final DateTime data;

  ProcedimentoModel({
    this.id,
    required this.clienteId,
    required this.titulo,
    required this.descricao,
    required this.valor,
    required this.data,
  });

  // Converte o ProcedimentoModel para um Map (útil para salvar em banco local ou enviar à API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'titulo': titulo,
      'descricao': descricao,
      'valor': valor,
      'data': data.toIso8601String(),
    };
  }

  // Constrói o ProcedimentoModel a partir de um Map (útil para carregar dados locais)
  factory ProcedimentoModel.fromMap(Map<String, dynamic> map) {
    return ProcedimentoModel(
      id: map['id'],
      clienteId: map['clienteId'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      valor: map['valor'],
      data: DateTime.parse(map['data']),
    );
  }

  // Método para construir ProcedimentoModel a partir de JSON (dados vindos da API)
  factory ProcedimentoModel.fromJson(Map<String, dynamic> json) {
    return ProcedimentoModel(
      id: json['id'],
      clienteId: json['clienteId'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      valor: json['valor'],
      data: DateTime.parse(json['data']),
    );
  }

  // Método para converter ProcedimentoModel para JSON (enviar dados para a API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clienteId': clienteId,
      'titulo': titulo,
      'descricao': descricao,
      'valor': valor,
      'data': data.toIso8601String(),
    };
  }
}
