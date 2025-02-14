class ReceitaModel {
  final int id;
  final int clienteId;
  final String titulo;
  final String descricao;
  final double valor;
  final DateTime data;
  final String servico;  // Adicionando o campo servico

  ReceitaModel({
    required this.id,
    required this.clienteId,
    required this.titulo,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.servico,  // Adicionando o campo servico
  });

  // Converte a ReceitaModel para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'titulo': titulo,
      'descricao': descricao,
      'valor': valor,
      'data': data.toIso8601String(),
      'servico': servico,  // Incluindo o campo servico
    };
  }

  // Constrói a ReceitaModel a partir de um Map
  factory ReceitaModel.fromMap(Map<String, dynamic> map) {
    return ReceitaModel(
      id: map['id'],
      clienteId: map['clienteId'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      valor: map['valor'],
      data: DateTime.parse(map['data']),
      servico: map['servico'],  // Incluindo o campo servico
    );
  }

  // Constrói a ReceitaModel a partir de JSON
  factory ReceitaModel.fromJson(Map<String, dynamic> json) {
    return ReceitaModel(
      id: json['id'],
      clienteId: json['clienteId'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      valor: json['valor'],
      data: DateTime.parse(json['data']),
      servico: json['servico'],  // Incluindo o campo servico
    );
  }

  // Converte a ReceitaModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clienteId': clienteId,
      'titulo': titulo,
      'descricao': descricao,
      'valor': valor,
      'data': data.toIso8601String(),
      'servico': servico,  // Incluindo o campo servico
    };
  }
}