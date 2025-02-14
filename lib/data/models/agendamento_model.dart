class AgendamentoModel {
  final int id;
  final int clienteId;
  final DateTime data;
  final String servico;

  AgendamentoModel({
    required this.id,
    required this.clienteId,
    required this.data,
    required this.servico,
  });

  // Converte o AgendamentoModel para um Map (útil para salvar em banco local ou enviar à API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'data': data.toIso8601String(),
      'servico': servico,
    };
  }

  // Constrói o AgendamentoModel a partir de um Map (útil para carregar dados locais)
  factory AgendamentoModel.fromMap(Map<String, dynamic> map) {
    return AgendamentoModel(
      id: map['id'],
      clienteId: map['clienteId'],
      data: DateTime.parse(map['data']),
      servico: map['servico'],
    );
  }

  // Método para construir AgendamentoModel a partir de JSON (dados vindos da API)
  factory AgendamentoModel.fromJson(Map<String, dynamic> json) {
    return AgendamentoModel(
      id: json['id'],
      clienteId: json['clienteId'],
      data: DateTime.parse(json['data']),
      servico: json['servico'],
    );
  }

  // Método para converter AgendamentoModel para JSON (enviar dados para a API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clienteId': clienteId,
      'data': data.toIso8601String(),
      'servico': servico,
    };
  }
}
