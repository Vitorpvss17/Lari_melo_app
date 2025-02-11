class ClienteModel {
  final int id;
  final String nome;
  final String sobrenome;
  final String telefone;
  final String email;
  final String foto;

  ClienteModel({
    required this.id,
    required this.nome,
    required this.sobrenome,
    required this.telefone,
    required this.email,
    required this.foto,
  });

  // Converte o ClienteModel para um Map (útil para salvar em um banco local ou enviar à API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'sobrenome': sobrenome,
      'telefone': telefone,
      'email': email,
      'foto': foto,
    };
  }

  // Constrói o ClienteModel a partir de um Map (útil para carregar dados locais)
  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'],
      nome: map['nome'],
      sobrenome: map['sobrenome'],
      telefone: map['telefone'],
      email: map['email'],
      foto: map['foto'],
    );
  }

  // Método para construir ClienteModel a partir de JSON (dados vindos da API)
  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'],
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      telefone: json['telefone'],
      email: json['email'],
      foto: json['foto'],
    );
  }

  // Método para converter ClienteModel para JSON (enviar dados para a API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'sobrenome': sobrenome,
      'telefone': telefone,
      'email': email,
      'foto': foto,
    };
  }
}