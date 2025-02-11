import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/cliente_model.dart';

class ClienteRepository {
  final String apiUrl = "http://127.0.0.1:5000/clientes/";
  final String apiUrl1 = "http://127.0.0.1:5000/clientes";// URL da sua API

  // Busca a lista de clientes
  Future<List<ClienteModel>> fetchClientes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => ClienteModel.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao carregar clientes");
    }
  }

  // Adiciona um novo cliente
  Future<void> addCliente(ClienteModel cliente) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cliente.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao adicionar cliente");
    }
  }

  // Atualiza um cliente existente
  Future<void> updateCliente(ClienteModel cliente) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${cliente.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cliente.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar cliente");
    }
  }

  // Deleta um cliente
  Future<void> deleteCliente(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl1/$id'));


    if (response.statusCode != 200) {
      throw Exception("Erro ao deletar cliente");
    }
  }
}